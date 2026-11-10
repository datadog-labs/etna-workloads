#!/usr/bin/env python3
"""Replay a gated injection in a slot and print the failing cases' output (for hand review).

  showfail.py <results.jsonl> <sha-prefix> <slotdir>
Applies the stored injection, builds, runs the failing cases once, prints the
runner output, then reverts and checks the slot against pristine.
"""
import json, os, subprocess, sys
import nodetest, slot as S
from gate import unit_of

res_file, prefix, slotdir = sys.argv[1:4]
r = next(json.loads(l) for l in open(res_file) if json.loads(l)["sha"].startswith(prefix))
patch = r["injection"].encode()
files = S.patch_files(r["injection"])
assert subprocess.run(["patch", "-p1", "-s", "--no-backup-if-mismatch"], cwd=slotdir,
                      input=patch).returncode == 0
try:
    cc = [c for c in r["failing"] if c.startswith("cctest:")]
    assert S.build(slotdir, cctest=bool(cc)), "build failed"
    js = sorted({unit_of(c) for c in r["failing"] if not c.startswith("cctest:")})
    scratch = os.path.expanduser("~/node-etna-work/tmp")
    res, out = nodetest.run_js(slotdir, os.path.join(slotdir, "out/Release/node"), js, scratch=scratch)
    rc, cout = nodetest.run_cctest(slotdir, cc)
    print(out[-6000:], cout[-3000:])
    print("statuses:", {**res, **rc})
finally:
    subprocess.run(["patch", "-p1", "-R", "-s", "--no-backup-if-mismatch"], cwd=slotdir, input=patch)
    bad = S.matches_pristine(slotdir, files)
    print("revert pristine:", "OK" if not bad else f"MISMATCH {bad}")
    if bad:
        S.restore(slotdir, files)
