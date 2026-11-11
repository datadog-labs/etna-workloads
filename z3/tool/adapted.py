#!/usr/bin/env python3
"""Adapted tier: an agent re-expresses the fix's bug in the release code; the harness gates it.
Usage: adapted.py [--slots 3] [--cap-usd X] [--limit K] [--only sha,..] [--model M] [--pool inrepo|z3test]
Results: data/adapted/<sha>.json (resumable; 'retry' redone)."""
import os, sys, json, argparse, threading, queue, time, shutil
sys.path.insert(0, os.path.dirname(__file__))
from agents import *

OUT = os.path.join(DATA, "adapted")
STAGE = "adapted"

PROMPT = """You are helping build a benchmark of REAL historical bugs in the Z3 SMT solver.

Your working directory contains:
  src/      a writable copy of the Z3 release z3-5.3.3 (this is the code you edit)
  build/    a configured Ninja build of src/ (Debug, assertions on). Do not reconfigure it.
  check.sh  builds src/ and runs the oracle unit tests; prints PASS/FAIL per unit.
  FIX.diff  the upstream fix commit (implementation and tests) that removed the bug.
  TASK.md   details about the fix and the oracle tests.

Goal: re-introduce into src/ the bug that the upstream fix removed, as it would look in
today's code, so that at least one oracle unit test FAILS while the tree still builds.
The upstream fix cannot simply be reversed on this release ({why}).

Rules (the harness checks them; violating them makes your work worthless):
- Change ONLY implementation files under src/src/ (C++ sources/headers). Never modify anything
  under src/src/test/, any CMakeLists.txt, build files, or test data. Do not touch build/ by hand.
- Every hunk you change must correspond to a hunk of the implementation part of FIX.diff: undo
  that hunk's effect in today's code. Do not invent new bugs, do not add unrelated breakage
  (no deliberate crashes, aborts, asserts, infinite loops or test-specific hacks keyed on test names).
- Keep the change minimal.
- Run ./check.sh after editing (a build takes from a few seconds up to ~10 minutes). Iterate until
  at least one oracle unit FAILS, preferably one of the units the fix added tests to: {fix_added}.
- When done, write RATIONALE.md in the working directory: for each changed hunk, which hunk of
  FIX.diff it traces to and why it reintroduces the same bug; and the final ./check.sh output.
- If you conclude the bug cannot be re-expressed faithfully (e.g. the code was rewritten and the
  bug cannot exist any more), restore src/ to the original (cp from {base_src}) and write
  RATIONALE.md starting with the line GIVEUP and the reason. Giving up honestly is fine.
The pristine release source is at {base_src} (read-only) for comparison, e.g.
  diff -ru {base_src}/src src/src
"""


def task_md(c, prior):
    return f"""# Fix {c['sha']}
Subject: {c['subject']}
Date (unix): {c['time']}
Issues: {', '.join('#' + i for i in c.get('issues', [])) or '-'}

Message:
{c['body'][:3000]}

Oracle units (pass on the release, run by ./check.sh): {' '.join(prior['oracle'])}
Units the fix added tests to: {' '.join(c.get('fix_added_units', [])) or '-'}
Verbatim reversal status: {prior.get('vstatus')}
"""


def prepare(slot, c, oracle, vstatus):
    s, src, build = slot_paths(slot)
    reset_slot(slot)
    for f in ("FIX.diff", "TASK.md", "RATIONALE.md", "check.sh", ".agent-out.json", ".agent-err.txt"):
        if os.path.exists(os.path.join(s, f)):
            os.remove(os.path.join(s, f))
    shutil.rmtree(os.path.join(s, ".tmp"), ignore_errors=True)
    os.makedirs(os.path.join(s, ".tmp"))
    open(os.path.join(s, "FIX.diff"), "w").write(git("show", "--no-color", c["sha"], "--", "src"))
    open(os.path.join(s, "TASK.md"), "w").write(task_md(c, dict(oracle=oracle, vstatus=vstatus)))
    to = max(gate_unit_timeout(u) for u in oracle)
    open(os.path.join(s, "check.sh"), "w").write(CHECK_SH.format(jobs=5, units=" ".join(oracle), timeout=to,
                                                                 z3test=Z3TEST))
    os.chmod(os.path.join(s, "check.sh"), 0o755)
    return s, src, build


def gate_unit_timeout(u):
    return unit_timeout(u)


def do_candidate(slot, c, vstatus, model, logdir):
    oracle = oracle_units(c["units"])
    s, src, build = prepare(slot, c, oracle, vstatus)
    cc = cmake_cache_hash(build)
    why = {"conflict": "the reversed diff does not apply", "noapply": "the reversed diff does not apply",
           "no_fail": "the reversed diff applies but no oracle test fails"}.get(vstatus, vstatus)
    prompt = PROMPT.format(why=why, fix_added=" ".join(c.get("fix_added_units", [])) or "(none)", base_src=BASE_SRC)
    if c.get("pool") == "z3test":
        prompt += ("\nThe oracle for this fix is a z3test regression file (z3 model_validate=true FILE must "
                   "print exactly FILE's .expected.out); ./check.sh runs it for you. The files are listed in "
                   f"TASK.md under the z3test: prefix, relative to {Z3TEST}.\n")
    a = run_agent(s, prompt, model=model, stage=STAGE, sha=c["sha"])
    rec = dict(sha=c["sha"], subject=c["subject"], slot=slot, model=model, agent=a, tier="adapted", vstatus=vstatus)
    rat = os.path.join(s, "RATIONALE.md")
    rec["rationale"] = open(rat, errors="replace").read() if os.path.exists(rat) else None
    if not a["ok"]:
        rec["status"] = "retry" if a.get("retryable") else "agent_error"
        return rec
    if cmake_cache_hash(build) != cc:
        rec["build_reconfigured"] = True
        shutil.rmtree(s, ignore_errors=True)  # slot will be rebuilt from scratch
        rec["status"] = "agent_reconfigured_build"
        return rec
    files = [f for f in changed_files(BASE_SRC, src)]
    rec["changed"] = files
    if rec["rationale"] is not None and rec["rationale"].lstrip().startswith("GIVEUP") and not files:
        rec["status"] = "giveup"
        return rec
    if not files:
        rec["status"] = "no_change"
        return rec
    if rec["rationale"] is None:
        rec["status"] = "no_rationale"
        return rec
    rec.update(gate_tree(slot, files, c["units"], os.path.join(logdir, c["sha"][:12] + ".log")))
    return rec


def worker(slot, q, logdir, stop, model, cap):
    ensure_slot(slot, os.path.join(logdir, f"slot{slot}.setup.log"))
    fast = []
    while not stop.is_set():
        if spent(STAGE) >= cap:
            print(f"[s{slot}] spend cap reached ${spent(STAGE):.2f}", flush=True)
            return
        try:
            c, vstatus = q.get_nowait()
        except queue.Empty:
            break
        t0 = time.time()
        try:
            rec = do_candidate(slot, c, vstatus, model, logdir)
        except Exception as e:
            import traceback
            rec = dict(sha=c["sha"], status="retry", error=traceback.format_exc()[-1500:])
        rec["secs"] = round(time.time() - t0)
        json.dump(rec, open(os.path.join(OUT, c["sha"] + ".json"), "w"), indent=1)
        print(f"[s{slot}] {c['sha'][:10]} {rec['status']} {rec.get('failing', '')} ${rec.get('agent', {}).get('usd', 0):.2f} {rec['secs']}s", flush=True)
        if rec["status"] in ("retry", "agent_error") and time.time() - t0 < 60:
            fast.append(rec.get("error", rec.get("agent", {}).get("error", ""))[:80])
            if len(fast) >= 4 and len(set(fast)) == 1:
                print(f"[s{slot}] STOP: identical fast failures: {fast[0]}", flush=True)
                stop.set()
                return
            if rec["status"] == "retry":
                time.sleep(120)
        else:
            fast = []
    reset_slot(slot)


def adapted_queue(pool, only="", retry_failed=False):
    cands = json.load(open(os.path.join(DATA, "candidates.json" if pool == "inrepo" else "candidates_z3test.json")))
    tri = os.path.join(DATA, "triage")
    q = []
    for c in cands:  # newest first
        if only and not any(c["sha"].startswith(x) for x in only.split(",")):
            continue
        if not oracle_units(c["units"]):
            continue
        vf = os.path.join(DATA, "verbatim", c["sha"] + ".json")
        if os.path.exists(vf):
            v = json.load(open(vf))
            if v["status"] == "pass_gate":
                continue
            vstatus = v["status"] if v["status"] in ("no_fail", "noapply", "build_fail", "empty_injection") else None
            if vstatus is None:
                continue
        elif c["apply"] == "conflict":
            vstatus = "conflict"
        else:
            continue  # verbatim not tried yet
        tf = os.path.join(tri, c["sha"] + ".json")
        if not only and os.path.exists(tf) and json.load(open(tf)).get("label") not in ("bug",):
            continue  # only triaged bugs get agents
        af = os.path.join(OUT, c["sha"] + ".json")
        if os.path.exists(af):
            prev = json.load(open(af))
            if retry_failed:
                if prev["status"] in ("pass_gate", "retry") or prev.get("model") != MODEL:
                    continue
                shutil.copy(af, af[:-5] + ".sonnet.json")
            elif prev["status"] != "retry":
                continue
        q.append((c, vstatus))
    return q


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--slots", type=int, default=3)
    ap.add_argument("--slot-base", type=int, default=0)
    ap.add_argument("--cap-usd", type=float, default=10)
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--only", default="")
    ap.add_argument("--model", default=MODEL)
    ap.add_argument("--pool", default="inrepo")
    ap.add_argument("--stage", default="adapted")
    ap.add_argument("--retry-failed", action="store_true")
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    logdir = os.path.join(WORK, "logs", "adapted")
    os.makedirs(logdir, exist_ok=True)
    global STAGE
    STAGE = a.stage
    items = adapted_queue(a.pool, a.only, a.retry_failed)
    if a.limit:
        items = items[: a.limit]
    print(f"{len(items)} to do; stage spend so far ${spent(STAGE):.2f}, cap ${a.cap_usd}", flush=True)
    q = queue.Queue()
    for it in items:
        q.put(it)
    stop = threading.Event()
    ts = [threading.Thread(target=worker, args=(a.slot_base + i, q, logdir, stop, a.model, a.cap_usd)) for i in range(a.slots)]
    for t in ts: t.start()
    for t in ts: t.join()


if __name__ == "__main__":
    main()
