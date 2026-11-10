#!/usr/bin/env python3
"""Print '<anchored>/<strict-capable>' for adapted bugs with a fix-added failing case."""
import json, os
D = os.path.expanduser("~/node-etna/data")
sc = set()
for f in ("adapted.jsonl", "adapted_retry.jsonl"):
    p = os.path.join(D, f)
    if os.path.exists(p):
        for l in open(p):
            r = json.loads(l)
            if r["status"] == "pass" and r["gate"].get("added_failing"):
                sc.add(r["sha"])
done = set()
p = os.path.join(D, "anchors.jsonl")
if os.path.exists(p):
    done = {json.loads(l)["sha"] for l in open(p)}
print(f"{len(sc & done)}/{len(sc)}")
