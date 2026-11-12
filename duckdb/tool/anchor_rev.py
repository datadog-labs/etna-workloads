#!/usr/bin/env python3
"""Second anchor worker: adapted gate passes without an anchor, OLDEST first, in its own slot (anchor2).
Runs alongside post_run.py's anchor thread (newest first) so the two meet in the middle; each checks for
an existing result before starting a candidate."""
import json, os, time, traceback
import common, anchor

ORDER = [c["sha"] for c in common.candidates()][::-1]
CANDS = {c["sha"]: c for c in common.candidates()}
import sys
SLOT = sys.argv[1] if len(sys.argv) > 1 else "anchor2"
src = os.path.join(common.WORK, "slots", SLOT, "src"); os.makedirs(src, exist_ok=True)
LOG = open(os.path.join(common.WORK, "logs", "post_run.log"), "a", buffering=1)
fast = 0
while True:
    todo = []
    for s in ORDER:
        p = f"{common.RESULTS}/adapted/{s}/result.json"
        if os.path.exists(p) and json.load(open(p)).get("verdict") == "pass" and \
                not os.path.exists(f"{common.RESULTS}/anchor/{s}/result.json") and \
                not os.path.exists(f"{common.RESULTS}/anchor/{s}/.claimed"):
            todo.append(s)
    if not todo:
        break
    s = todo[0]
    os.makedirs(f"{common.RESULTS}/anchor/{s}", exist_ok=True)
    open(f"{common.RESULTS}/anchor/{s}/.claimed", "w").write(SLOT)
    out = f"{common.RESULTS}/anchor/{s}/result.json"
    try:
        r = anchor.anchor(src, CANDS[s], json.load(open(f"{common.RESULTS}/adapted/{s}/result.json"))["failing"], os.path.dirname(out))
    except Exception:
        r = {"sha": s, "status": "infra", "error": traceback.format_exc()[-1500:]}
    if not os.path.exists(out):
        common.write_json(out, r)
    LOG.write(time.strftime("%Y-%m-%d %H:%M:%S ") + f"{SLOT} {s[:10]} {r.get('status')}\n")
    b = r.get("rev_build") or r.get("fix_build") or {}
    fast = fast + 1 if str(r.get("status", "")).startswith(("build-fail", "infra")) and b.get("secs", 999) < 60 else 0
    if fast >= 3:
        LOG.write(time.strftime("%Y-%m-%d %H:%M:%S ") + "anchor2 STOP: 3 identical fast failures (tooling bug?)\n")
        break
