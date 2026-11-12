#!/usr/bin/env python3
"""Verbatim tier worker: reverse each candidate's src/ hunks on the release in a fixed build slot, gate it.

usage: verbatim.py SLOT_SRC [--shas FILE] [--limit N] [--worker K --nworkers N]
Results: results/verbatim/<sha>/result.json (+ injection.patch, logs). Resumable: done shas are skipped
unless their verdict was 'infra'. Candidates are processed newest first.
A worker stops after 5 consecutive identical fast failures (a tooling bug, not a result).
"""
import argparse, json, os, shutil, sys, time
import common, gate, repro, verbatim_lib
from common import sh

ap = argparse.ArgumentParser()
ap.add_argument("slot"); ap.add_argument("--shas"); ap.add_argument("--limit", type=int)
ap.add_argument("--worker", type=int, default=0); ap.add_argument("--nworkers", type=int, default=1)
ap.add_argument("--jobs", type=int, default=6)
a = ap.parse_args()
slot = os.path.abspath(a.slot)
base = common.base_oracle()
probe = {r["sha"]: r["apply"] for r in common.load_jsonl(os.path.join(common.WORK, "probe.jsonl"))}
umap = common.units_map()
cands = [c for c in common.candidates() if probe.get(c["sha"]) in ("clean", "fuzzy")]
if a.shas:
    want = [l.split()[0] for l in open(a.shas) if l.strip()]
    order = {s: i for i, s in enumerate(want)}
    cands = sorted([c for c in cands if c["sha"] in order], key=lambda c: order[c["sha"]])
cands = [c for i, c in enumerate(cands) if i % a.nworkers == a.worker]
if a.limit:
    cands = cands[:a.limit]

fast_fail = []
for c in cands:
    if os.path.exists(os.path.join(common.WORK, "STOP")):
        print("STOP file present; exiting"); break
    out = os.path.join(common.RESULTS, "verbatim", c["sha"])
    rp = os.path.join(out, "result.json")
    if os.path.exists(rp) and json.load(open(rp)).get("verdict") != "infra":
        continue
    res = verbatim_lib.run_one(slot, c, base, umap, jobs=a.jobs)
    print(f"{c['sha'][:10]} {res['verdict']:12s} {len(res.get('failing', []))} failing  {res.get('wall_secs')}s", flush=True)
    sig = (res["verdict"], tuple(res.get("build_errors", [])[:1]))
    if res["verdict"] in ("build-fail", "infra") and res.get("build", {}).get("secs", 999) < 60:
        fast_fail.append(sig)
        if len(fast_fail) >= 5 and len(set(fast_fail[-5:])) == 1:
            print("5 identical fast failures; stopping worker (tooling bug?)", fast_fail[-1]); sys.exit(3)
    else:
        fast_fail = []
