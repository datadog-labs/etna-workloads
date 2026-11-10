#!/usr/bin/env python3
"""Verify every slot's lib/ and src/ against pristine; restore any drift (e.g. after an
interrupted run).  Prints what was restored."""
import glob, os, sys
sys.path.insert(0, os.path.dirname(__file__))
import agents, slot as S

for d in sorted(glob.glob(os.path.join(S.W, "slots", "*"))):
    drift = S.scope_drift(d)
    if drift:
        print(f"{os.path.basename(d)}: drift, restoring:\n{drift[:1000]}")
        agents.restore_slot(d)
    else:
        print(f"{os.path.basename(d)}: pristine")
