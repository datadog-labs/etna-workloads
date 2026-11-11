"""Anchor: at the original fix commit C, build C with its implementation reversed
(parent's implementation + the fix's tests) and run the oracle units there.

exact   = some unit that fails in the adapted gate also fails (both runs) at the anchor
other   = anchor fails, but on different units only
none    = nothing fails at the anchor
build-fails / no-units = recorded honestly
Results: data/anchor/<sha>.json
"""
import argparse, json, os, re, shutil, subprocess, threading, queue, time, traceback
from pathlib import Path
from common import *
from slots import sh, RESULT_RE, ANSI, parse_result

OUT = DATA / "anchor"
ADIR = WORK / "anchors"
LOCK = threading.Lock()
# v2: success requires `make world.opt` + ocamlc (v1 accepted old `make`'s help text, exit 0);
#     modern-gcc/glibc compatibility (no -Werror, -fcommon, fixed SIGSTKSZ) on retry.
# v3: no RLIMIT_AS (it broke OCaml 5 runtimes: "Not enough heap memory to start up");
#     every anchor produced by v1/v2 is re-run.
TOOL_VERSION = 3


def checkout(sha, dst):
    if dst.exists():
        subprocess.run(["chmod", "-R", "u+w", str(dst)])
        shutil.rmtree(dst)
    with LOCK:
        git("worktree", "prune")
        git("worktree", "add", "--detach", "-f", str(dst), sha)


def remove(dst):
    subprocess.run(["chmod", "-R", "u+w", str(dst)])
    shutil.rmtree(dst, ignore_errors=True)
    with LOCK:
        git("worktree", "prune")


def configure_and_build(src, log, jobs):
    """Build an old revision.  Success = `make world.opt` succeeds AND produces ocamlc
    (old `make` without a target prints help and exits 0, so it is never a fallback).
    Compatibility for a modern gcc (allowed for anchors): retries without -Werror and with
    -fcommon (needed before 4.10).  Returns (status, env) with status ok|no-ocamltest|build-failed."""
    prefix = src.parent / "inst"
    compat = {"CC": "gcc -fcommon"}
    if (src / "configure.ac").exists():
        base = ["./configure", f"--prefix={prefix}", "--enable-ocamltest"]
        attempts = [(base, {}, False),
                    (base + ["--disable-warn-error"], compat, False)]
    else:   # pre-4.08 hand-written configure
        attempts = [(["./configure", "-prefix", str(prefix)], {}, False),
                    (["./configure", "-prefix", str(prefix), "-cc", "gcc -fcommon"], {}, True)]
    for i, (cmd, extra, strip_werror) in enumerate(attempts):
        if i:   # not `git clean`: it would delete files the reversal re-created
            sh(["make", "distclean"], src, log)
            sh(["make", "clean"], src, log)
        env = dict(os.environ, **{k: v for k, v in extra.items() if isinstance(v, str)})
        if sh(cmd, src, log, env=env) != 0:
            continue
        if i:   # glibc >= 2.34: SIGSTKSZ is no longer a constant (old native runtimes)
            for f in ("asmrun/signals_asm.c", "runtime/signals_nat.c"):
                p = src / f
                if p.exists() and "[SIGSTKSZ]" in p.read_text():
                    p.write_text(p.read_text().replace("[SIGSTKSZ]", "[65536]"))
                    extra = dict(extra, sigstksz_compat=True)
        if strip_werror:
            for cfg in ("config/Makefile", "Makefile.config"):
                p = src / cfg
                if p.exists():
                    p.write_text(p.read_text().replace("-Werror", ""))
        if sh(["make", f"-j{jobs}", "world.opt"], src, log, timeout=3600, env=env) != 0 \
                or not (src / "ocamlc").exists():
            continue
        if (src / "ocamltest").is_dir():
            if sh(["make", f"-j{jobs}", "ocamltest"], src, log, timeout=1800, env=env) != 0:
                sh(["make", "-C", "ocamltest", f"-j{jobs}"], src, log, timeout=1800, env=env)
        if (src / "ocamltest" / "ocamltest").exists():
            return "ok", dict(extra, strip_werror=strip_werror)
        return "no-ocamltest", dict(extra, strip_werror=strip_werror, reason="pre-ocamltest revision")
    return "build-failed", None


def run_unit(src, unit, priv_root):
    ts = src / "testsuite"
    if not (ts / unit).exists():
        return "missing", ""
    priv = priv_root / f"u{abs(hash((unit, time.time())))}"
    priv.mkdir(parents=True)
    env = dict(os.environ, SORT="sort", MAKE="make", TERM="dumb", USE_RUNTIME="d",
               OCAMLRUNPARAM="v=0", OCAMLTESTDIR=str(priv), TMPDIR=str(priv))
    help_ = subprocess.run(["../ocamltest/ocamltest", "-help"], cwd=ts, capture_output=True, text=True).stdout
    args = ["../ocamltest/ocamltest"] + (["-timeout", "300"] if "-timeout" in help_ else []) + [unit]
    try:
        from slots import limit_mem
        r = subprocess.run(args, cwd=ts, env=env, capture_output=True, text=True, errors="replace", timeout=900,
                           preexec_fn=limit_mem())
        out = ANSI.sub("", r.stdout + r.stderr)
    except subprocess.TimeoutExpired:
        shutil.rmtree(priv, ignore_errors=True)
        return "timeout", ""
    shutil.rmtree(priv, ignore_errors=True)
    return parse_result(unit, out, r.returncode)


def anchor(c, units, jobs=6):
    """units: release unit paths (failing in the adapted gate first)."""
    wd = ADIR / c["sha"][:12]
    wd.mkdir(parents=True, exist_ok=True)
    src = wd / "src"
    res = dict(sha=c["sha"], units=units)
    try:
        checkout(c["sha"], src)
        d = git("diff", "--binary", "--no-renames", f"{c['sha']}^", c["sha"], "--", *c["impl_files"])
        r = subprocess.run(["git", "apply", "-R", "-"], cwd=src, input=d, text=True, capture_output=True)
        if r.returncode:
            res["status"] = "reverse-failed"
            return res
        present = [u for u in units if (src / "testsuite" / u).exists()]
        res["present_units"] = present
        if not present:
            res["status"] = "no-units"
            return res
        if not (src / "ocamltest").is_dir():
            res["status"] = "no-ocamltest"
            res["reason"] = "pre-ocamltest revision (legacy Makefile testsuite; not ported)"
            return res
        st, extra = configure_and_build(src, wd / "build.log", jobs)
        res["build"] = st
        res["build_env"] = extra
        if st != "ok":
            res["status"] = "build-fails" if st == "build-failed" else st
            res["build_log_tail"] = (wd / "build.log").read_text(errors="replace")[-2500:]
            return res
        runs = [{u: run_unit(src, u, wd / "runs") for u in present} for _ in range(2)]
        res["runs"] = [{u: s for u, (s, _) in r.items()} for r in runs]
        res["failing"] = [u for u in present if runs[0][u][0] in ("failed", "error", "timeout", "no-result")
                          and runs[1][u][0] in ("failed", "error", "timeout", "no-result")]
        res["detail"] = {u: runs[0][u][1][-1200:] for u in res["failing"]}
        return res
    finally:
        remove(src)
        shutil.rmtree(wd, ignore_errors=True)


def classify(res, gate_failing):
    if "status" in res:
        return res["status"]
    if set(res["failing"]) & set(gate_failing):
        return "exact"
    return "other" if res["failing"] else "none"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--par", type=int, default=4)
    ap.add_argument("--only", default="")
    a = ap.parse_args()
    OUT.mkdir(parents=True, exist_ok=True)
    cands = {c["sha"]: c for c in load("candidates.json")}
    todo = []
    for f in sorted((DATA / "adapted").glob("*.json")):
        r = json.loads(f.read_text())
        prev = json.loads((OUT / f.name).read_text()) if (OUT / f.name).exists() else None
        stale = prev is not None and prev.get("tool", 1) < TOOL_VERSION
        if r.get("gate") and not r.get("retryable") and (prev is None or prev.get("retryable") or stale):
            if a.only and not any(r["sha"].startswith(k) for k in a.only.split(",")):
                continue
            todo.append((cands[r["sha"]], r))
    todo.sort(key=lambda t: -t[0]["ts"])
    print(len(todo), "anchors to run", flush=True)
    q = queue.Queue()
    for t in todo:
        q.put(t)

    def worker():
        while True:
            try:
                c, r = q.get_nowait()
            except queue.Empty:
                return
            disk_wait()
            t = time.time()
            units = r["failing"] + [u for u in r["oracle"] if u not in r["failing"]]
            try:
                res = anchor(c, units)
            except Exception:
                res = dict(sha=c["sha"], status="error", error=traceback.format_exc(), retryable=True)
            res["anchor"] = classify(res, r["failing"])
            res["tool"] = TOOL_VERSION
            disk_taint(res)
            res["secs"] = round(time.time() - t)
            (OUT / f"{c['sha']}.json").write_text(json.dumps(res, indent=1))
            print(c["sha"][:10], res["anchor"], res.get("failing"), res["secs"], "s", flush=True)

    ths = [threading.Thread(target=worker) for _ in range(a.par)]
    for t in ths:
        t.start()
    for t in ths:
        t.join()


if __name__ == "__main__":
    main()
