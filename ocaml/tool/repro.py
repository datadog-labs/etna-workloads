"""Reproducer stage: an agent writes repro/repro.sh (+ one single-file program) such that
`sh repro.sh PREFIX` behaves differently on the clean and on the injected installed compiler.

Verification is done here, never by the agent's word, in a build slot:
  clean  = release snapshot, `make install` into the slot prefix, run twice
  buggy  = injection applied, clean rebuild, install, run twice
Verified iff clean output is deterministic and both buggy runs differ from clean in
output AND exit status.  Paths are normalised before comparing.
"""
import argparse, json, os, queue, re, shutil, subprocess, threading, time, traceback
from pathlib import Path
from common import *
import gate as G, llm, sandbox
from agentdir import fresh_tree
from slots import Slot, sh, RELEASE_SRC, CONFIGURE_FLAGS

OUT = DATA / "repro"
RAGENTS = WORK / "repro-agents"

PROMPT = """You are writing a reproducer for a bug that was injected into the OCaml {release} compiler/runtime.

Working directory:
  clean-inst/   the correct compiler, installed (bin/ocamlc, bin/ocamlopt, bin/ocaml, lib/ocaml, ...)
  buggy-inst/   the same release with the bug injected, installed the same way
  BUG.md        the upstream fix this bug comes from, the injected patch, and the failing test
Do not modify clean-inst/ or buggy-inst/.

Write repro/repro.sh and at most one program file next to it (e.g. repro/repro.ml, or repro/repro.c
if a C stub is truly needed). Contract:
  sh repro/repro.sh PREFIX
compiles and/or runs the program with the compiler installed in PREFIX (use "$1/bin/ocamlc",
"$1/bin/ocamlopt" or "$1/bin/ocaml"; never anything else on the machine). It must print a short
deterministic result and exit 0 when the behaviour is correct, and print something different and
exit 1 when the bug shows (a crash, a wrong result, a wrong error message, an accepted invalid
program...). Catch the buggy behaviour explicitly (e.g. compare the program's output with the
expected one, check the compiler's exit status, wrap with `timeout` for hangs).
Rules:
- The script runs from a different directory with a different PREFIX path: use only $1 and paths
  relative to the script's own directory (`cd "$(dirname "$0")"`), and write temporary files under
  $TMPDIR or a fresh `mktemp -d` that you delete.
- Never print paths, versions, timestamps, process ids or addresses; never inspect the source code
  or the compiler binaries themselves - only observe behaviour.
- Base it on the failing test, but keep it small.
Check it really works: run `sh repro/repro.sh $PWD/clean-inst` twice (same output, exit 0) and
`sh repro/repro.sh $PWD/buggy-inst` (different output, exit 1). Finish with a final line:
RESULT: ok   (or RESULT: gave-up with the reason).
"""


def norm(s, *paths):
    for p in paths:
        s = s.replace(str(p), "<P>")
    s = re.sub(r"/[\w./-]*ocaml-etna-work[\w./-]*", "<PATH>", s)
    return s


def run_repro(rdir, prefix, priv):
    priv.mkdir(parents=True, exist_ok=True)
    work = priv / "r"
    shutil.rmtree(work, ignore_errors=True)
    shutil.copytree(rdir, work)
    tmp = priv / "tmp"
    tmp.mkdir(exist_ok=True)
    env = {"PATH": "/usr/bin:/bin", "HOME": str(priv), "TMPDIR": str(tmp), "LANG": "C"}
    try:
        r = subprocess.run(["sh", str(work / "repro.sh"), str(prefix)], cwd=priv, env=env,
                           capture_output=True, text=True, errors="replace", timeout=600,
                           preexec_fn=__import__("slots").limit_mem())
        out, rc = r.stdout + r.stderr, r.returncode
    except subprocess.TimeoutExpired:
        out, rc = "<harness timeout>", -9
    shutil.rmtree(work, ignore_errors=True)
    shutil.rmtree(tmp, ignore_errors=True)
    return norm(out, prefix, priv, work)[-4000:], rc


def install(slot):
    inst = slot.root / "inst"
    shutil.rmtree(inst, ignore_errors=True)
    return sh(["make", "install"], slot.src, slot.root / "install.log", timeout=1200) == 0


def verify(slot, rdir, inj):
    """Harness verification of a reproducer in a slot."""
    res = {}
    slot.reset()
    prefix = slot.root / "inst"
    if not install(slot):
        return dict(verified=False, why="clean install failed")
    c = [run_repro(rdir, prefix, slot.root / "rp" / f"c{i}") for i in (1, 2)]
    subprocess.run(["git", "apply", "-"], cwd=slot.src, input=inj, text=True, check=True)
    if slot.build(clean=True) != "ok" or not install(slot):
        return dict(verified=False, why="buggy build/install failed")
    b = [run_repro(rdir, prefix, slot.root / "rp" / f"b{i}") for i in (1, 2)]
    shutil.rmtree(slot.root / "rp", ignore_errors=True)
    shutil.rmtree(prefix, ignore_errors=True)
    res.update(clean=c, buggy=b)
    det = c[0] == c[1]
    differs = all(x[0] != c[0][0] and x[1] != c[0][1] for x in b)
    res["deterministic"] = det
    res["verified"] = det and differs
    if not det:
        res["why"] = "clean output not deterministic"
    elif not differs:
        res["why"] = "buggy does not differ in both output and exit status"
    return res


def bug_md(c, inj, failing, detail):
    tests = []
    for u in failing[:2]:
        p = RELEASE_SRC / "testsuite" / u
        if p.exists():
            tests.append(f"### {u}\n```\n{p.read_text(errors='replace')[:6000]}\n```\n"
                         f"Failure on the buggy build (excerpt):\n```\n{norm(detail.get(u, ''))[-1500:]}\n```\n")
    return (f"# Upstream fix\ncommit {c['sha']}  ({c['date'][:10]})\n\n{c['subject']}\n\n{c['body'][:3000]}\n\n"
            f"# Injected patch (applied to the release to create the bug)\n```diff\n{inj[:12000]}\n```\n\n"
            f"# Failing test(s)\n" + "\n".join(tests))


def prepare(c, inj):
    wd = RAGENTS / c["sha"][:12]
    if wd.exists():
        subprocess.run(["chmod", "-R", "u+w", str(wd)])
        shutil.rmtree(wd)
    wd.mkdir(parents=True)
    ok = True
    for name, patch in (("clean", None), ("buggy", inj)):
        tree = wd / f"{name}-src"
        shutil.copytree(RELEASE_SRC, tree, symlinks=True)
        subprocess.run(["chmod", "-R", "u+w", str(tree)], check=True)
        if patch:
            subprocess.run(["git", "apply", "-"], cwd=tree, input=patch, text=True, check=True)
        lg = wd / f"{name}.log"
        ok = ok and sh(["./configure", *CONFIGURE_FLAGS, f"--prefix={wd}/{name}-inst"], tree, lg) == 0 \
            and sh(["make", "-j6"], tree, lg, timeout=3600) == 0 and sh(["make", "install"], tree, lg) == 0
        subprocess.run(["chmod", "-R", "u+w", str(tree)])
        shutil.rmtree(tree)       # the agent gets installed compilers only
    return wd if ok else None


def bugs_for_repro():
    out = []
    cands = {c["sha"]: c for c in load("candidates.json")}
    for tier, d, pd in (("verbatim", DATA / "verbatim", DATA / "patches"),
                        ("adapted", DATA / "adapted", DATA / "patches_adapted")):
        for f in d.glob("*.json"):
            r = json.loads(f.read_text())
            if r.get("gate"):
                out.append((cands[r["sha"]], r, (pd / f"{r['sha']}.patch").read_text(errors="surrogateescape")))
    out.sort(key=lambda t: -t[0]["ts"])
    return out


def process(slot, c, r, inj, model, budget):
    res = dict(sha=c["sha"], tier=r["tier"], model=model)
    wd = prepare(c, inj)
    if wd is None:
        res["skip"] = "prepare-failed"
        return res
    (wd / "BUG.md").write_text(bug_md(c, inj, r["failing"], r.get("fail_detail", {})), errors="surrogateescape")
    subprocess.run(["chmod", "-R", "a-w", str(wd / "clean-inst"), str(wd / "buggy-inst")])
    out, info = sandbox.run_agent(PROMPT.format(release=RELEASE), wd, "repro", c["sha"], model=model,
                                  timeout=3600, budget=budget)
    res["agent"] = info
    res["agent_result"] = (out or "")[-2000:]
    if out is None and info.get("retryable"):
        res["retryable"] = True
        return res
    rdir = wd / "repro"
    if not (rdir / "repro.sh").exists():
        res["skip"] = "no-repro"
        return res
    res["agent_files"] = sorted(p.name for p in rdir.iterdir())
    keep = keep_sources(rdir, DATA / "repro_files" / c["sha"])
    if keep is None:
        res["skip"] = "no-single-program"
        return res
    res["files"] = sorted(p.name for p in keep.iterdir())
    res.update(verify(slot, keep, inj))
    return res


PROGRAM_EXT = (".ml", ".c", ".mli", ".mll", ".mly")


def keep_sources(rdir, keep):
    """Keep repro.sh and at most one program file; never build leftovers (.cmi, .o, ...)."""
    progs = sorted(p for p in rdir.iterdir() if p.is_file() and p.suffix in PROGRAM_EXT)
    if len(progs) > 1:
        named = [p for p in progs if p.stem == "repro"]
        if len(named) != 1:
            return None
        progs = named
    shutil.rmtree(keep, ignore_errors=True)
    keep.mkdir(parents=True)
    shutil.copy(rdir / "repro.sh", keep / "repro.sh")
    for p in progs:
        shutil.copy(p, keep / p.name)
    return keep


def cleanup(c):
    wd = RAGENTS / c["sha"][:12]
    subprocess.run(["chmod", "-R", "u+w", str(wd)])
    shutil.rmtree(wd, ignore_errors=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--cap", type=float, required=True)
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--par", type=int, default=3)
    ap.add_argument("--first-slot", type=int, default=8)
    ap.add_argument("--model", default="sonnet")
    ap.add_argument("--budget-per-agent", type=float, default=2.5)
    ap.add_argument("--only", default="")
    ap.add_argument("--strict-only", action="store_true")
    ap.add_argument("--retry-failed", action="store_true",
                    help="re-run agents whose reproducer did not verify (keeps the first attempt in 'previous')")
    a = ap.parse_args()
    OUT.mkdir(parents=True, exist_ok=True)
    todo = bugs_for_repro()
    if a.only:
        todo = [t for t in todo if any(t[0]["sha"].startswith(k) for k in a.only.split(","))]
    if a.strict_only:
        import report
        st = report.strict_set()
        todo = [t for t in todo if t[0]["sha"] in st]

    def done(c):
        f = OUT / f"{c['sha']}.json"
        if not f.exists():
            return False
        r = json.loads(f.read_text())
        if a.retry_failed:
            return bool(r.get("verified")) or bool(r.get("previous"))
        return not r.get("retryable")
    todo = [t for t in todo if not done(t[0])]
    if a.limit:
        todo = todo[:a.limit]
    print(len(todo), "reproducers to write; spent", round(llm.spent("repro"), 2), flush=True)
    if not sandbox.sbx_check()[0]["ok"]:
        print("SANDBOX CHECK FAILED; not launching", flush=True)
        return
    q = queue.Queue()
    for t in todo:
        q.put(t)

    def worker(n):
        slot = Slot(n)
        if not slot.prepare():
            return
        while True:
            if llm.spent("repro") >= a.cap:
                print("cap reached", flush=True)
                return
            try:
                c, r, inj = q.get_nowait()
            except queue.Empty:
                return
            disk_wait()
            t = time.time()
            try:
                res = process(slot, c, r, inj, a.model, a.budget_per_agent)
            except Exception:
                res = dict(sha=c["sha"], error=traceback.format_exc(), retryable=True)
            res["secs"] = round(time.time() - t)
            prevf = OUT / f"{c['sha']}.json"
            if a.retry_failed and prevf.exists():
                res["previous"] = json.loads(prevf.read_text())
            disk_taint(res)
            if res.get("retryable"):
                res["verified"] = False
            (OUT / f"{c['sha']}.json").write_text(json.dumps(res, indent=1))
            print(c["sha"][:10], "verified=", res.get("verified"), res.get("why", ""), res.get("skip", ""),
                  "cost=", res.get("agent", {}).get("cost"), res["secs"], "s", flush=True)
            cleanup(c)
            slot.reset()

    ths = [threading.Thread(target=worker, args=(a.first_slot + i,)) for i in range(a.par)]
    for t in ths:
        t.start()
    for t in ths:
        t.join()


if __name__ == "__main__":
    main()
