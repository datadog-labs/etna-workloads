#!/usr/bin/env python3
"""Verbatim tier: reverse the fix's implementation hunks on the release and gate it.
Usage: verbatim.py [--slots N] [--limit K] [--only sha,...]
Resumable: results in data/verbatim/<sha>.json; 'retry' results are redone."""
import os, sys, json, argparse, threading, queue, time, shutil
sys.path.insert(0, os.path.dirname(__file__))
from gate import *

OUT = os.path.join(DATA, "verbatim")


def do_candidate(slot, c, logdir):
    s, src, build = slot_paths(slot)
    reset_slot(slot)
    log = os.path.join(logdir, c["sha"][:12] + ".log")
    rec = dict(sha=c["sha"], subject=c["subject"], slot=slot, started=time.time())
    patch = impl_diff(c["sha"], c["impl"])
    mode = apply_patch(src, patch, reverse=True)
    rec["apply"] = mode
    if mode is None:
        rec["status"] = "noapply"
        return rec
    files = changed_files(BASE_SRC, src)
    rec.update(gate_tree(slot, files, c["units"], log))
    rec["tier"] = "verbatim"
    rec["secs"] = round(time.time() - rec["started"])
    return rec


def worker(slot, q, logdir, stop):
    log = os.path.join(logdir, f"slot{slot}.setup.log")
    ensure_slot(slot, log)
    fast_same = []
    while not stop.is_set():
        try:
            c = q.get_nowait()
        except queue.Empty:
            return
        t0 = time.time()
        try:
            rec = do_candidate(slot, c, logdir)
        except Exception as e:
            rec = dict(sha=c["sha"], status="retry", error=repr(e))
        json.dump(rec, open(os.path.join(OUT, c["sha"] + ".json"), "w"), indent=1)
        print(f"[s{slot}] {c['sha'][:10]} {rec['status']} {rec.get('failing', '')} {round(time.time()-t0)}s", flush=True)
        # stop the worker after several identical fast failures (tooling bug guard)
        key = (rec["status"], rec.get("build"), rec.get("error", "")[:80])
        if time.time() - t0 < 20 and rec["status"] in ("retry", "build_fail"):
            fast_same.append(key)
        else:
            fast_same = []
        if len(fast_same) >= 4 and len(set(fast_same)) == 1:
            print(f"[s{slot}] STOP: 4 identical fast failures {key}", flush=True)
            stop.set()
            return
    reset_slot(slot)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--slots", type=int, default=3)
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--only", default="")
    ap.add_argument("--include-conflict", action="store_true")
    ap.add_argument("--pool", default="all")
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    logdir = os.path.join(WORK, "logs", "verbatim")
    os.makedirs(logdir, exist_ok=True)
    cands = []
    if a.pool in ("inrepo", "all"):
        cands += json.load(open(os.path.join(DATA, "candidates.json")))
    if a.pool in ("z3test", "all"):
        cands += json.load(open(os.path.join(DATA, "candidates_z3test.json")))
    cands.sort(key=lambda c: -c["time"])  # newest first
    todo = []
    for c in cands:
        if a.only and not any(c["sha"].startswith(x) for x in a.only.split(",")):
            continue
        if not a.include_conflict and c["apply"] == "conflict" and not a.only:
            continue
        f = os.path.join(OUT, c["sha"] + ".json")
        if os.path.exists(f) and json.load(open(f))["status"] != "retry":
            continue
        todo.append(c)
    if a.limit:
        todo = todo[: a.limit]
    print(f"{len(todo)} to do", flush=True)
    q = queue.Queue()
    for c in todo:
        q.put(c)
    stop = threading.Event()
    ts = [threading.Thread(target=worker, args=(i, q, logdir, stop)) for i in range(a.slots)]
    for t in ts: t.start()
    for t in ts: t.join()


if __name__ == "__main__":
    main()
