#!/usr/bin/env python3
"""Run every test-z3 unit twice on the base build. Writes data/base_units.json."""
import os, sys, json, subprocess, concurrent.futures as cf
sys.path.insert(0, os.path.dirname(__file__))
from z3lab import *

def list_units(build):
    out = subprocess.run([os.path.join(build, "test-z3"), "/h"], capture_output=True, text=True).stdout
    units, on = [], False
    for l in out.splitlines():
        if l.startswith("Module names"): on = True; continue
        if on and l.startswith("    ") and "(...)" not in l: units.append(l.strip())
    return units

def main():
    workers = int(sys.argv[1]) if len(sys.argv) > 1 else 8
    timeout = int(sys.argv[2]) if len(sys.argv) > 2 else 1200
    units = list_units(BASE_BUILD)
    res = {u: [] for u in units}
    jobs = [(u, r) for r in (0, 1) for u in units]
    with cf.ThreadPoolExecutor(workers) as ex:
        futs = {ex.submit(run_unit, BASE_BUILD, u, timeout): (u, r) for u, r in jobs}
        for f in cf.as_completed(futs):
            u, r = futs[f]
            x = f.result()
            res[u].append(x)
            print(r, u, x["status"], x["detail"], x["secs"], flush=True)
    summary = {}
    for u, xs in res.items():
        sts = [x["status"] for x in xs]
        summary[u] = dict(runs=[{k: x[k] for k in ("status", "detail", "secs")} for x in xs],
                          stable_pass=sts == ["pass", "pass"],
                          max_secs=max(x["secs"] for x in xs), tails=[x["tail"][-600:] for x in xs if x["status"] != "pass"])
    json.dump(summary, open(os.path.join(DATA, "base_units.json"), "w"), indent=1)
    sp = sum(v["stable_pass"] for v in summary.values())
    print(f"units {len(units)} stable_pass {sp}")
    for u, v in summary.items():
        if not v["stable_pass"]: print("NOT-PASS", u, [r["status"] + ":" + r["detail"] for r in v["runs"]])

if __name__ == "__main__":
    main()
