#!/usr/bin/env python3
"""Collect every gated bug (verbatim + adapted passes) into one JSONL for later stages."""
import argparse, json, os

ap = argparse.ArgumentParser()
ap.add_argument("--cands", required=True)
ap.add_argument("--verbatim", required=True)
ap.add_argument("--adapted", nargs="+", default=[])
ap.add_argument("--out", required=True)
a = ap.parse_args()
cands = {json.loads(l)["sha"]: json.loads(l) for l in open(a.cands)}
bugs = {}
for l in open(a.verbatim):
    r = json.loads(l)
    if r["status"] == "pass":
        bugs[r["sha"]] = dict(r, tier="verbatim")
for f in a.adapted:
    if not os.path.exists(f):
        continue
    for l in open(f):
        r = json.loads(l)
        if r["status"] == "pass" and r["sha"] not in bugs:
            g = r["gate"]
            bugs[r["sha"]] = dict(sha=r["sha"], tier="adapted", injection=g["injection"],
                                  failing=g["failing"], added_failing=g.get("added_failing", []),
                                  oracle=g["oracle"], inj_runs=g.get("inj_runs"),
                                  locality=r.get("locality"), source=f)
with open(a.out, "w") as fo:
    for sha, b in bugs.items():
        c = cands[sha]
        b.update(subject=c["subject"], body=c["body"], date=c["date"])
        fo.write(json.dumps(b) + "\n")
print(f"bugs: {len(bugs)}")
