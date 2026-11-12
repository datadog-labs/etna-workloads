#!/usr/bin/env python3
"""Retry the mechanical reproducer for gated results that have none (rebuilds the injection in SLOT).
usage: repro_mech.py SLOT_SRC RESULT_JSON..."""
import json, os, sys
import common, gate, repro

slot = os.path.abspath(sys.argv[1])
for rp in sys.argv[2:]:
    r = json.load(open(rp)); rdir = os.path.dirname(os.path.abspath(rp))
    if r.get("verdict") != "pass" or r.get("repro"):
        continue
    common.sync_tree(slot)
    gate.apply_patch(slot, open(os.path.join(rdir, "injection.patch"), "rb").read())
    b = gate.build(slot, os.path.join(rdir, "repro-mech-build.log"))
    if b["status"] == "exit" and b["rc"] == 0:
        details = {u: r["runs"][0][u][1] for u in r["failing"]}
        rep, att = repro.mechanical(common.BASE, slot, r["failing"], details)
        r["repro"], r["repro_attempts"] = rep, att
        if rep:
            open(os.path.join(rdir, "repro.sql"), "w").write(rep["sql"])
        common.write_json(rp, r)
        print(r["sha"][:10], bool(rep), att, flush=True)
    common.sync_tree(slot)
