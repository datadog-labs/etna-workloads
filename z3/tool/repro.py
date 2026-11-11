#!/usr/bin/env python3
"""Reproducers: an agent writes repro.smt2 whose z3 output/exit status differs between the clean and
the injected build; the harness verifies it (never the agent's word).
Usage: repro.py [--slots 3] [--cap-usd X] [--only sha,..] [--limit K]  -> data/repro/<sha>.json + .smt2"""
import os, sys, json, argparse, threading, queue, time, re, shutil
sys.path.insert(0, os.path.dirname(__file__))
from agents import *

OUT = os.path.join(DATA, "repro")
STAGE = "repro"
REPRO_TIMEOUT = 30

PROMPT = """You are helping build a benchmark of real historical bugs in the Z3 SMT solver.
A known historical bug has been re-injected into this tree (INJECTION.diff, applied to src/), and
build/z3 is the BUGGY z3 binary. The CLEAN release binary is {clean_z3} (read-only).
FIX.diff is the upstream fix; FAILING.txt lists the unit tests that fail on the buggy build and how.

Task: write repro.smt2 in this directory, a standalone SMT-LIB2 script (you may use (set-option ...)
and (set-logic ...)), such that running
    z3 repro.smt2
gives a different stdout/stderr or exit status with build/z3 than with the clean binary, e.g. a
wrong sat/unsat, a wrong or invalid model (use (get-model)/(get-value) or model_validate via
(set-option :model_validate true)), an assertion violation, a crash, or an error.
Requirements:
- The clean binary must answer deterministically within {timeout} s (run it a few times to check).
- Do not print versions, paths, statistics, timings or anything else that differs for reasons other
  than the bug. Do not use (get-info :version) or (get-info :reason-unknown).
- Check your file with:  ./compare.sh repro.smt2     (runs both binaries and shows outputs)
- Write NOTES.md: what you tried, the final compare.sh output. If you cannot find a reproducer
  through the z3 binary (e.g. the bug is only reachable through an internal API), say so in
  NOTES.md and do not write repro.smt2.
Do not modify src/, build/ or anything outside this directory's repro.smt2 and NOTES.md (scratch
files in .tmp/ are fine).
"""

COMPARE_SH = """#!/bin/bash
# Usage: ./compare.sh FILE.smt2
cd "$(dirname "$0")"
here="$PWD"
f="$1"
for b in clean bug; do
  if [ $b = clean ]; then z={clean_z3}; else z="$here/build/z3"; fi
  d=$(mktemp -d .tmp/cmp.XXXX); cp "$f" $d/in.smt2
  ( cd $d; ulimit -v 8000000; timeout -s KILL {timeout} setsid $z in.smt2 < /dev/null > out.txt 2>&1; echo "exit=$?" >> out.txt )
  echo "== $b"; head -c 3000 $d/out.txt; rm -rf $d
done
"""

NORM = [(re.compile(re.escape(p)), "<SRC>") for p in (SLOTS, BASE_SRC, BASE, WORK)]


def normalize(out):
    out = re.sub(r"/[^\s:]*?/src/src/", "<SRC>/src/", out)
    for r, s in NORM:
        out = r.sub(s, out)
    return out


def run_repro(z3bin_dir, smt2):
    rc, out, to = run_smt2(z3bin_dir, smt2, REPRO_TIMEOUT, args=())
    return ("timeout" if to else rc), normalize(out)


def verify(smt2, bug_build):
    """Harness verification. Returns (ok, detail dict)."""
    text = open(smt2, errors="replace").read()
    if re.search(r"get-info\s+:(version|reason-unknown|name|authors)", text):
        return False, dict(reason="prints version/info")
    clean = [run_repro(BASE_BUILD, smt2) for _ in range(3)]
    if len(set(clean)) != 1:
        return False, dict(reason="clean nondeterministic", clean=clean)
    if clean[0][0] == "timeout":
        return False, dict(reason="clean times out")
    bug = [run_repro(bug_build, smt2) for _ in range(2)]
    if any(b == clean[0] for b in bug):
        return False, dict(reason="no difference", clean=clean[0], bug=bug)
    return True, dict(clean_rc=clean[0][0], clean_out=clean[0][1], bug_rc=[b[0] for b in bug],
                      bug_out=bug[0][1][-3000:])


def gated_bugs():
    out = []
    for tier in ("verbatim", "adapted"):
        d = os.path.join(DATA, tier)
        if not os.path.isdir(d):
            continue
        for f in os.listdir(d):
            r = json.load(open(os.path.join(d, f)))
            if r.get("status") == "pass_gate":
                out.append(r)
    return out


def do_bug(slot, r, cands, model):
    s, src, build = slot_paths(slot)
    reset_slot(slot)
    for f in os.listdir(s):
        if f not in ("src", "build", "ready"):
            p = os.path.join(s, f)
            shutil.rmtree(p) if os.path.isdir(p) else os.remove(p)
    os.makedirs(os.path.join(s, ".tmp"))
    rr = subprocess.run(["git", "apply"], cwd=src, input=r["injection"], text=True, capture_output=True)
    if rr.returncode != 0:
        return dict(status="inject_fail", error=rr.stderr)
    st, _ = ninja(build, os.path.join(WORK, "logs", "repro", r["sha"][:12] + ".log"))
    if st != "ok":
        return dict(status="retry" if st == "error" else "build_fail")
    open(os.path.join(s, "INJECTION.diff"), "w").write(r["injection"])
    open(os.path.join(s, "FIX.diff"), "w").write(git("show", "--no-color", r["sha"], "--", "src"))
    fl = []
    for u in r["failing"]:
        t = r["results"][u][0]
        fl.append(f"== {u}: {t['detail']}\n{t.get('tail', '')[-800:]}\n")
    open(os.path.join(s, "FAILING.txt"), "w").write("\n".join(fl))
    open(os.path.join(s, "compare.sh"), "w").write(COMPARE_SH.format(clean_z3=os.path.join(BASE_BUILD, "z3"),
                                                                        timeout=REPRO_TIMEOUT))
    os.chmod(os.path.join(s, "compare.sh"), 0o755)
    cc = cmake_cache_hash(build)
    a = run_agent(s, PROMPT.format(clean_z3=os.path.join(BASE_BUILD, "z3"), timeout=REPRO_TIMEOUT),
                  model=model, max_turns=60, timeout=2400, stage=STAGE, sha=r["sha"])
    rec = dict(agent=a, model=model)
    if os.path.exists(os.path.join(s, "NOTES.md")):
        rec["notes"] = open(os.path.join(s, "NOTES.md"), errors="replace").read()[-6000:]
    if not a["ok"]:
        rec["status"] = "retry" if a.get("retryable") else "agent_error"
        return rec
    # the agent must not have altered the injected tree
    changed = changed_files(BASE_SRC, src)
    if cmake_cache_hash(build) != cc or tree_diff(BASE_SRC, src, changed) != r["injection"]:
        rec["status"] = "agent_modified_tree"
        shutil.rmtree(s, ignore_errors=True)
        return rec
    smt2 = os.path.join(s, "repro.smt2")
    if not os.path.exists(smt2):
        rec["status"] = "no_repro"
        return rec
    ok, det = verify(smt2, build)
    rec["verify"] = det
    rec["status"] = "verified" if ok else "rejected"
    shutil.copy(smt2, os.path.join(OUT, r["sha"] + ".smt2"))
    return rec


def worker(slot, q, stop, model, cap, cands):
    ensure_slot(slot, os.path.join(WORK, "logs", "repro", f"slot{slot}.setup.log"))
    while not stop.is_set():
        if spent(STAGE) >= cap:
            print(f"[s{slot}] spend cap reached", flush=True); break
        try:
            r = q.get_nowait()
        except queue.Empty:
            break
        t0 = time.time()
        try:
            rec = do_bug(slot, r, cands, model)
        except Exception:
            import traceback
            rec = dict(status="retry", error=traceback.format_exc()[-1500:])
        rec.update(sha=r["sha"], tier=r["tier"], secs=round(time.time() - t0))
        json.dump(rec, open(os.path.join(OUT, r["sha"] + ".json"), "w"), indent=1)
        print(f"[s{slot}] {r['sha'][:10]} {rec['status']} ${rec.get('agent', {}).get('usd', 0):.2f} {rec['secs']}s", flush=True)
    reset_slot(slot)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--slots", type=int, default=3)
    ap.add_argument("--slot-base", type=int, default=0)
    ap.add_argument("--cap-usd", type=float, default=5)
    ap.add_argument("--only", default="")
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--model", default=MODEL)
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    os.makedirs(os.path.join(WORK, "logs", "repro"), exist_ok=True)
    cands = {c["sha"]: c for f in ("candidates.json", "candidates_z3test.json")
             for c in json.load(open(os.path.join(DATA, f)))}
    bugs = [r for r in gated_bugs() if not a.only or any(r["sha"].startswith(x) for x in a.only.split(","))]
    bugs = [r for r in bugs if not (os.path.exists(os.path.join(OUT, r["sha"] + ".json")) and
                                    json.load(open(os.path.join(OUT, r["sha"] + ".json")))["status"] != "retry")]
    bugs.sort(key=lambda r: -cands[r["sha"]]["time"])
    if a.limit:
        bugs = bugs[: a.limit]
    print(len(bugs), "reproducers to do", flush=True)
    q = queue.Queue()
    for r in bugs: q.put(r)
    stop = threading.Event()
    ts = [threading.Thread(target=worker, args=(a.slot_base + i, q, stop, a.model, a.cap_usd, cands)) for i in range(a.slots)]
    for t in ts: t.start()
    for t in ts: t.join()


if __name__ == "__main__":
    main()
