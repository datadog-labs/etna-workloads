#!/usr/bin/env python3
"""Validate a build slot against the base: rebuild, run all oracle suites, compare.
usage: validate_slot.py N    -> prints mismatches; exit 1 if any."""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from common import DATA, WORK  # noqa: E402
import runner  # noqa: E402
import slot as slotmod  # noqa: E402

SUITES = ["tests/ui", "tests/crashes", "tests/mir-opt", "tests/codegen-llvm", "tests/codegen-units",
          "tests/incremental", "tests/assembly-llvm"]
n = int(sys.argv[1])
s = slotmod.path(n)
slotmod.reset(s)
log = os.path.join(WORK, "runs", f"validate-s{n}")
c1, _ = runner.build(s, log + "-build.log")
c2, _ = runner.build_library(s, log + "-lib.log")
code, secs, cases, _ = runner.test(s, SUITES, log + "-test.log", timeout=3600)
base = json.load(open(os.path.join(DATA, "base_cases.json")))
bad = sorted(k for k, v in base.items() if v == "pass" and cases.get(k) != "ok")
print(f"s{n}: build {c1}/{c2}, test exit {code} in {secs:.0f}s, ok={sum(v == 'ok' for v in cases.values())}, "
      f"mismatches={len(bad)} {bad[:10]}", flush=True)
sys.exit(1 if bad or c1 or c2 else 0)
