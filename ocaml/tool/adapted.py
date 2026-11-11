"""Adapted stage: an agent re-expresses the fix's bug in the release code.

usage: adapted.py --cap USD [--limit N] [--par K] [--model sonnet] [--only sha,...]
Per candidate: prepare WORK/agents/<sha12>/ (fresh configured+built release copy),
launch the sandboxed agent, extract the implementation-only diff, gate it in a slot.
Results: data/adapted/<sha>.json, patches data/patches_adapted/<sha>.patch
"""
import argparse, json, queue, re, shutil, subprocess, threading, time, traceback
from pathlib import Path
from common import *
import gate as G, llm, sandbox
from agentdir import AGENTS, fresh_tree, changed_tracked, run_oracle_script
from slots import Slot, RELEASE_SRC

OUT = DATA / "adapted"
PDIR = DATA / "patches_adapted"

PROMPT = """You are helping build a benchmark of realistic bugs for the OCaml compiler and runtime.

The working directory contains:
  ocaml/            the OCaml {release} release source, already configured and built in place
  FIX.md            an upstream bug-fix commit (message, date, Changes entry)
  fix.diff          the full upstream fix (implementation and tests)
  ORACLE.txt        test files (relative to ocaml/testsuite/) that pass on the release
  run-oracle.sh     runs those tests on ocaml/ (prints "=> passed" / "=> failed" per test)

The fix is from {date}; the code has changed since, so reversing fix.diff does not
directly work on the release ({why}). Your task: RE-INTRODUCE THE BUG THAT THIS FIX
REMOVED into today's code in ocaml/, so that at least one test in ORACLE.txt fails.

Rules (strict):
- Edit only implementation files under ocaml/ (compiler, runtime, stdlib, otherlibs:
  parsing/ typing/ lambda/ middle_end/ asmcomp/ bytecomp/ file_formats/ utils/ driver/
  runtime/ stdlib/ otherlibs/). Never edit anything under ocaml/testsuite/, test data,
  Makefiles, configure, build files or ocamltest/.
- Every hunk you change must correspond to a hunk of the fix: undo what the fix did,
  re-expressed in today's code. Do not invent a different bug, and do not make the code
  fail in some unrelated way (no deliberately broken builds, no crashes unrelated to the fix).
- Keep the change minimal. Do not leave comments that point at the bug.
- If you edit parsing/parser.mly you must also make the equivalent change to the checked-in
  generated parser boot/menhir/parser.ml (menhir is not available); prefer avoiding .mly.
- No network access is available; everything you need is local.

Build and test loop (run it for real):
  cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh
Incremental builds can fail with "inconsistent assumptions" after stdlib/runtime edits;
then run `make clean` first. Before finishing, do one final `make clean && make -j8 &&
make -j8 ocamltest` and run run-oracle.sh, and confirm at least one test fails.
Use $TMPDIR for scratch files.

When done, write RATIONALE.md in the working directory: for each hunk you changed, the file,
what it does, and which hunk of fix.diff it reverses (quote the fix hunk header). Also
record the build-and-test commands you ran and their results.
Finish with a final line: RESULT: injected  (or RESULT: gave-up, with the reason).
"""


def prepare(c, oracle, why):
    wd = AGENTS / c["sha"][:12]
    if wd.exists():
        subprocess.run(["chmod", "-R", "u+w", str(wd)])
        shutil.rmtree(wd)
    wd.mkdir(parents=True)
    ok = fresh_tree(wd / "ocaml", wd / "inst", wd / "prepare.log", jobs=6)
    if not ok:
        return None
    news = git("diff", "-U0", f"{c['sha']}^", c["sha"], "--", "Changes", check=False)
    news = "\n".join(l[1:] for l in news.splitlines() if l.startswith("+") and not l.startswith("+++"))
    (wd / "FIX.md").write_text(f"commit {c['sha']}\nDate: {c['date']}\nAuthor: {c['author']}\n\n"
                               f"{c['subject']}\n\n{c['body']}\n\nChanges entry:\n{news or '(none)'}\n")
    (wd / "fix.diff").write_text(git("show", "--format=", "--no-renames", c["sha"]), errors="surrogateescape")
    (wd / "ORACLE.txt").write_text("\n".join(oracle) + "\n")
    (wd / "run-oracle.sh").write_text(run_oracle_script(wd / "ocaml", oracle))
    return wd


def process(slot, c, model, why, budget, stage="adapted"):
    res = dict(sha=c["sha"], subject=c["subject"], date=c["date"], tier="adapted", model=model)
    oracle = G.oracle_for(c["sha"])
    res["oracle"] = oracle
    if not oracle:
        res["skip"] = "no-oracle"
        return res
    wd = prepare(c, oracle, why)
    if wd is None:
        res["skip"] = "prepare-failed"
        return res
    prompt = PROMPT.format(release=RELEASE, date=c["date"][:10], why=why)
    out, info = sandbox.run_agent(prompt, wd, stage, c["sha"], model=model, timeout=5400, budget=budget)
    res["agent"] = info
    res["agent_result"] = (out or "")[-3000:]
    if out is None and info.get("retryable"):
        res["retryable"] = True
        return res
    orl = wd / "oracle-runs.log"
    res["oracle_runs_log"] = orl.read_text(errors="replace")[-3000:] if orl.exists() else None
    res["oracle_runs"] = res["oracle_runs_log"].count("=== ") if res["oracle_runs_log"] else 0
    if out and "safety classifier" in out:
        res["classifier_blocked"] = True
    rat = wd / "RATIONALE.md"
    res["rationale"] = rat.read_text(errors="replace") if rat.exists() else None
    changed = changed_tracked(wd / "ocaml")
    impl = [p for p in changed if is_impl(p)]
    res["changed_non_impl"] = [p for p in changed if not is_impl(p)]
    res["changed_impl"] = impl
    if not impl:
        res["skip"] = "no-impl-change"
        return res
    # harness-side evidence that the agent rebuilt after its last edit
    last_edit = max((wd / "ocaml" / p).stat().st_mtime for p in impl if (wd / "ocaml" / p).exists())
    built = [wd / "ocaml" / x for x in ("ocamlc", "ocamlopt", "runtime/ocamlrun") if (wd / "ocaml" / x).exists()]
    res["agent_rebuilt_after_edit"] = bool(built) and max(b.stat().st_mtime for b in built) >= last_edit
    inj = G.diff_trees(impl, RELEASE_SRC, wd / "ocaml")
    PDIR.mkdir(parents=True, exist_ok=True)
    (PDIR / f"{c['sha']}.patch").write_text(inj, errors="surrogateescape")
    res.update(G.gate(slot, inj, oracle, "ad-" + c["sha"][:12]))
    from verbatim import added_tests
    res["fix_added_units"] = added_tests(c["sha"])
    res["fails_added"] = [u for u in res.get("failing", []) if u in res["fix_added_units"]]
    res["gate"] = G.passes_gate(res)
    fixfiles = set(c["impl_files"])
    res["locality"] = ("same-files" if set(impl) <= fixfiles else
                       "overlap" if set(impl) & fixfiles else
                       "same-dirs" if {p.split('/')[0] for p in impl} <= {p.split('/')[0] for p in fixfiles} else
                       "disjoint")
    return res


def cleanup(c):
    wd = AGENTS / c["sha"][:12]
    keep = WORK / "agent-notes" / c["sha"][:12]
    keep.mkdir(parents=True, exist_ok=True)
    for f in ("RATIONALE.md", "FIX.md"):
        if (wd / f).exists():
            shutil.copy(wd / f, keep / f)
    subprocess.run(["chmod", "-R", "u+w", str(wd)])
    shutil.rmtree(wd, ignore_errors=True)


WIN = re.compile(r"win32|windows|mingw|msvc|cygwin|_nt\.|\bnt\b|winsock", re.I)


def windows_specific(c):
    """Fixes that only matter on Windows cannot fail on this Linux host."""
    return all(WIN.search(f) for f in c["impl_files"]) or bool(WIN.search(c["subject"]))


def eligible():
    """Candidates for adaptation: triaged bug, with oracle, verbatim did not pass the gate."""
    tri = load("triage.json", {})
    probe = {r["sha"]: r for r in load("probe.json")}
    out = []
    for c in sorted(load("candidates.json"), key=lambda c: -c["ts"]):
        t = tri.get(c["sha"])
        if not t or t["label"] != "bug" or not G.oracle_for(c["sha"]):
            continue
        if windows_specific(c):
            continue
        vf = DATA / "verbatim" / f"{c['sha']}.json"
        if vf.exists():
            v = json.loads(vf.read_text())
            if v.get("gate") or v.get("retryable"):
                continue
            why = ("the reversed fix applies but no oracle test fails" if v.get("build") == "ok" else
                   "the reversed fix applies but does not build" if v.get("build") else
                   "the reversed fix does not apply")
        elif probe[c["sha"]]["status"] == "conflict":
            why = "the reversed fix does not apply"
        else:
            continue    # verbatim not run yet
        out.append((c, why))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--cap", type=float, required=True)
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--par", type=int, default=3)
    ap.add_argument("--first-slot", type=int, default=5)
    ap.add_argument("--model", default="sonnet")
    ap.add_argument("--budget-per-agent", type=float, default=5.0)
    ap.add_argument("--only", default="")
    a = ap.parse_args()
    OUT.mkdir(parents=True, exist_ok=True)
    todo = eligible()
    if a.only:
        ks = a.only.split(",")
        todo = [t for t in todo if any(t[0]["sha"].startswith(k) for k in ks)]

    def done(c):
        f = OUT / f"{c['sha']}.json"
        return f.exists() and not json.loads(f.read_text()).get("retryable")
    todo = [t for t in todo if not done(t[0])]
    if a.limit:
        todo = todo[:a.limit]
    print(len(todo), "to adapt; spent so far", round(llm.spent("adapted"), 2), flush=True)
    q = queue.Queue()
    for t in todo:
        q.put(t)
    ok, msg = sandbox.sbx_check()[0]["ok"], ""
    if not ok:
        print("SANDBOX CHECK FAILED; not launching", flush=True)
        return

    def worker(n):
        slot = Slot(n)
        if not slot.prepare():
            print("slot prepare failed", n, flush=True)
            return
        while True:
            if llm.spent("adapted") >= a.cap:
                print("cap reached", flush=True)
                return
            try:
                c, why = q.get_nowait()
            except queue.Empty:
                return
            disk_wait()
            t = time.time()
            try:
                res = process(slot, c, a.model, why, a.budget_per_agent)
            except Exception:
                res = dict(sha=c["sha"], error=traceback.format_exc(), retryable=True)
            res["secs"] = round(time.time() - t)
            disk_taint(res)
            (OUT / f"{c['sha']}.json").write_text(json.dumps(res, indent=1))
            print(c["sha"][:10], "gate=", res.get("gate"), "fail=", res.get("failing"), res.get("skip", ""),
                  "cost=", res.get("agent", {}).get("cost"), res["secs"], "s",
                  "spent", round(llm.spent("adapted"), 2), flush=True)
            cleanup(c)
            slot.reset()

    ths = [threading.Thread(target=worker, args=(a.first_slot + i,)) for i in range(a.par)]
    for t in ths:
        t.start()
    for t in ths:
        t.join()


if __name__ == "__main__":
    main()
