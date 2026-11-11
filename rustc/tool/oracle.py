#!/usr/bin/env python3
"""Oracle cases per candidate: fix's test cases that pass in BOTH base runs.

usage: oracle.py            # (re)build data/base_cases.json and data/oracles.json
"""
import json
import os
import sys
from collections import Counter

sys.path.insert(0, os.path.dirname(__file__))
from common import DATA, WORK  # noqa: E402
import runner  # noqa: E402

RUNS = [os.path.join(WORK, "runs", f"base-{i}.log") for i in (1, 2)]


def base_cases():
    runs = [runner.parse(open(p, errors="replace").read())[0] for p in RUNS]
    allk = set(runs[0]) | set(runs[1])
    out = {}
    for k in allk:
        a, b = runs[0].get(k), runs[1].get(k)
        out[k] = "pass" if a == b == "ok" else ("ignored" if a == b == "ignored" else f"unstable:{a}/{b}")
    return out


def build():
    base = base_cases()
    # Cases that fail under the per-process memory limit used for test runs.
    lim = os.path.join(DATA, "limit_excluded.json")
    for k in (json.load(open(lim)) if os.path.exists(lim) else []):
        base[k] = "excluded:memory-limit"
    json.dump(base, open(os.path.join(DATA, "base_cases.json"), "w"))
    by_file = {}
    for k, v in base.items():
        by_file.setdefault(runner.case_file(k), []).append(k)
    orcs = {}
    for line in open(os.path.join(DATA, "testmap.jsonl")):
        r = json.loads(line)
        cases, added = [], {}
        for e in r["cases"]:
            p = e["release_path"]
            if not p or not e["oracle_suite"]:
                continue
            added[p] = added.get(p, False) or e["added"]
            cases += [k for k in by_file.get(p, []) if base[k] == "pass"]
        orcs[r["commit"]] = dict(cases=sorted(set(cases)), added=added)
    json.dump(orcs, open(os.path.join(DATA, "oracles.json"), "w"))
    print("base:", Counter(v.split(":")[0] for v in base.values()))
    print("unstable:", [k for k, v in base.items() if v.startswith("unstable")][:20])
    print("candidates with oracle cases:", sum(1 for o in orcs.values() if o["cases"]), "/", len(orcs))


def load():
    return json.load(open(os.path.join(DATA, "oracles.json")))


if __name__ == "__main__":
    build()
