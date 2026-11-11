#!/bin/bash
# Reordered continuation (2026-11-09 21:30): headline work before the non-headline z3test pool.
# Same approved caps; every stage resumable.
cd "$(dirname "$0")"
L=~/z3-etna-work/logs
stage() { echo "=== $(date -Is) $*" >> $L/chain.out; }
ANCHOR1=2157699   # anchor pass 1 already running (exact PID)
stage retry-opus;      python3 adapted.py --pool inrepo --stage retry_opus --model claude-opus-5-5 --retry-failed --cap-usd 25 --slots 3 >> $L/adapted_retry.out 2>&1
stage repro;           python3 repro.py --slots 3 --cap-usd 50 >> $L/repro.out 2>&1
stage wait-anchor1;    while kill -0 $ANCHOR1 2>/dev/null; do sleep 60; done
stage anchor2+z3test-resume
python3 anchor.py >> $L/anchor.out 2>&1 &
A2=$!
python3 adapted.py --pool z3test --stage adapted_z3test --cap-usd 60 --slots 3 >> $L/adapted_z3test.out 2>&1
wait $A2
stage anchor3+repro2
python3 anchor.py >> $L/anchor.out 2>&1 &
A3=$!
python3 repro.py --slots 3 --cap-usd 50 >> $L/repro.out 2>&1
wait $A3
stage done
