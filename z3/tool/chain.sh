#!/bin/bash
# Unattended full run (resumable: every stage skips finished items). Caps approved 2026-11-09.
cd "$(dirname "$0")"
L=~/z3-etna-work/logs
stage() { echo "=== $(date -Is) $*" >> $L/chain.out; }
# 1. verbatim (waits for an already-running verbatim pass to finish first)
if [ -f $L/verbatim_full.pid ]; then while kill -0 $(cat $L/verbatim_full.pid) 2>/dev/null; do sleep 60; done; fi
stage verbatim;          python3 verbatim.py --slots 3 >> $L/verbatim_full.out 2>&1
stage adapted-inrepo;    python3 adapted.py --pool inrepo --stage adapted --cap-usd 110 --slots 3 >> $L/adapted_inrepo.out 2>&1
stage anchor+adapted-z3test
python3 anchor.py >> $L/anchor.out 2>&1 &
APID=$!
python3 adapted.py --pool z3test --stage adapted_z3test --cap-usd 60 --slots 3 >> $L/adapted_z3test.out 2>&1
wait $APID
stage retry-opus;        python3 adapted.py --pool inrepo --stage retry_opus --model claude-opus-5-5 --retry-failed --cap-usd 25 --slots 3 >> $L/adapted_retry.out 2>&1
stage anchor2;           python3 anchor.py >> $L/anchor.out 2>&1
stage repro;             python3 repro.py --slots 3 --cap-usd 50 >> $L/repro.out 2>&1
stage done
