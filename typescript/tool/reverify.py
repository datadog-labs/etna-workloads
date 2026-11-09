#!/usr/bin/env python3
"""Re-verify exported reproducers from the workload files alone: fresh tree +
injection.patch + build, then repro.check; also compare against expected files."""
import json, os, sys
from concurrent.futures import ThreadPoolExecutor
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import inject, repro, tstree

def one(bd):
    name = os.path.basename(bd)
    t = os.path.join(tstree.WORK, "trees", "rv-" + name[-8:])
    tstree.rm_tree(t); tstree.mk_tree(t)
    try:
        ok, _, _ = inject.apply_patch(t, open(f"{bd}/injection.patch", "rb").read())
        if not ok or not tstree.build(t, t + ".log")[0]:
            return name, "build/apply failed"
        v = repro.check(f"{bd}/repro", tstree.BASE, t)
        exp_c = open(f"{bd}/repro/expected_clean.txt").read()
        exp_i = open(f"{bd}/repro/expected_injected.txt").read()
        same = exp_c == f"exit={v['clean']['rc']}\n{v['clean']['out']}" and exp_i == f"exit={v['injected']['rc']}\n{v['injected']['out']}"
        if "--rewrite" in FLAGS and v["verified"] and not same:
            open(f"{bd}/repro/expected_clean.txt", "w").write(f"exit={v['clean']['rc']}\n{v['clean']['out']}")
            open(f"{bd}/repro/expected_injected.txt", "w").write(f"exit={v['injected']['rc']}\n{v['injected']['out']}")
        return name, f"verified={v['verified']} matches_expected={same} {v['why']}"
    finally:
        tstree.rm_tree(t)
        if os.path.exists(t + ".log"): os.unlink(t + ".log")

FLAGS = [a for a in sys.argv[1:] if a.startswith("--")]
with ThreadPoolExecutor(6) as ex:
    for n, r in ex.map(one, [a for a in sys.argv[1:] if not a.startswith("--")]):
        print(n, r, flush=True)
