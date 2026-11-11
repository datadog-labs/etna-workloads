#!/usr/bin/env python3
"""Run every z3test regression referenced by the z3test pool twice on the base. -> data/base_z3test.json"""
import os, sys, json, concurrent.futures as cf, time
sys.path.insert(0, os.path.dirname(__file__))
from z3lab import *
cases = sorted({u for p in json.load(open(os.path.join(DATA, "candidates_z3test.json"))) for u in p["units"]})
res = {c: [] for c in cases}
def one(c):
    t = time.time(); r = run_case(BASE_BUILD, c, 120); r["secs"] = round(time.time() - t, 1); return r
with cf.ThreadPoolExecutor(int(sys.argv[1]) if len(sys.argv) > 1 else 6) as ex:
    for c, r in zip(cases * 2, ex.map(one, cases * 2)):
        res[c].append(r)
summ = {c: dict(runs=[{k: r[k] for k in ("status", "detail", "secs")} for r in rs],
                stable_pass=[r["status"] for r in rs] == ["pass", "pass"], max_secs=max(r["secs"] for r in rs))
        for c, rs in res.items()}
json.dump(summ, open(os.path.join(DATA, "base_z3test.json"), "w"), indent=1)
import collections
print(len(cases), "stable_pass", sum(v["stable_pass"] for v in summ.values()),
      collections.Counter(tuple(r["status"] + ":" + r["detail"] for r in v["runs"]) for v in summ.values()))
