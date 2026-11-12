#!/usr/bin/env python3
"""Extra adapted workers on slots freed when the verbatim queue empties.
Skips the first SKIP pending candidates (newest first) so it never meets run_all's adapted workers,
which take candidates from the newest end; same caps, deadline, STOP file and credential checks.
usage: extra_adapted.py --slots s1,s2,s3 --skip 40 --cap-adapted 180 --deadline EPOCH"""
import argparse, json, os, threading, time, traceback
import common, llm, adapt

ap = argparse.ArgumentParser()
ap.add_argument("--slots", required=True); ap.add_argument("--skip", type=int, default=40)
ap.add_argument("--cap-adapted", type=float, required=True); ap.add_argument("--deadline", type=float, required=True)
a = ap.parse_args()
LOG = open(os.path.join(common.WORK, "logs", "run_all.log"), "a", buffering=1)
def log(*x): LOG.write(time.strftime("%Y-%m-%d %H:%M:%S ") + "X " + " ".join(map(str, x)) + "\n")

base = common.base_oracle(); um = common.units_map()
PROBE = {r["sha"]: r["apply"] for r in common.load_jsonl(os.path.join(common.WORK, "probe.jsonl"))}
def tri(s):
    p = f"{common.RESULTS}/triage/{s}.json"
    return json.load(open(p)).get("label") if os.path.exists(p) else None
def oracle(s): return [u for u in um[s]["units"] if base.get(u) == "pass"]
def added(s): return [u for u in um[s]["added"] if base.get(u) == "pass"]
def done(s): return os.path.exists(f"{common.RESULTS}/adapted/{s}/result.json")
cands = common.candidates()
pending = [c for c in cands if PROBE[c["sha"]] == "conflict" and tri(c["sha"]) == "bug" and added(c["sha"]) and not done(c["sha"])]
queue = pending[a.skip:]
lock = threading.Lock()
log("extra_adapted start", len(pending), "pending; taking from index", a.skip)

def worker(name):
    slot = os.path.join(common.WORK, "slots", name)
    while time.time() < a.deadline and not os.path.exists(os.path.join(common.WORK, "STOP")):
        if llm.spent("adapted") >= a.cap_adapted:
            return
        with lock:
            if not queue:
                return
            c = queue.pop(0)
        if done(c["sha"]):
            continue
        while not llm.credential_ok():
            time.sleep(120)
        outdir = f"{common.RESULTS}/adapted/{c['sha']}"; os.makedirs(outdir, exist_ok=True)
        try:
            r = adapt.adapt(slot, c, oracle(c["sha"]), "does not apply", "sonnet", 5.0, 10800, outdir)
        except Exception:
            r = {"sha": c["sha"], "verdict": "infra", "error": traceback.format_exc()[-1500:]}
        common.write_json(os.path.join(outdir, "result.json"), r)
        log(name, "adapted", c["sha"][:10], r.get("verdict"), r.get("failing"), "$%.3f" % r.get("agent", {}).get("cost", 0))

ts = [threading.Thread(target=worker, args=(n,)) for n in a.slots.split(",")]
for t in ts: t.start()
for t in ts: t.join()
log("extra_adapted end")
