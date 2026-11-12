#!/usr/bin/env python3
"""Run every needed test unit twice on the read-only base build: results/base/run{1,2}.json."""
import json, os, sys, time
import common, runtests

units = [l.strip() for l in open(os.path.join(common.WORK, "all_units.txt")) if l.strip()]
jobs = int(sys.argv[1]) if len(sys.argv) > 1 else 12
os.makedirs(os.path.join(common.RESULTS, "base"), exist_ok=True)
for i in (1, 2):
    out = os.path.join(common.RESULTS, "base", f"run{i}.json")
    if os.path.exists(out):
        continue
    t0 = time.time()
    res = runtests.run_units(common.BASE, units, jobs=jobs, timeout=900, rss_mb=16000)
    common.write_json(out, {u: {"outcome": o, "detail": d} for u, (o, d) in res.items()})
    from collections import Counter
    print(f"run{i}", round(time.time() - t0), "s", Counter(o for o, _ in res.values()), flush=True)
