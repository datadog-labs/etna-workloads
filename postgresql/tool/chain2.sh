#!/bin/sh
# Unattended full run, v2 (resumable; touch ~/pg-etna-work/STOP to stop between items).
# Caps (USD): adapted 150, adapted_retry 50, repro 60.  Triage done (cap 5).
# verbatim.py runs as its own process; adapted slots w0-w3 start when it exits.
T=$(dirname "$0"); W=${ETNA_WORK:-$HOME/pg-etna-work}; cd "$W" || exit 1
log() { echo "$(date -Is) $*" >> "$W/logs/chain.log"; }
stopped() { [ -e "$W/STOP" ]; }
log "chain2 start"
python3 "$T/adapted.py" --cap 150 --workers w4,w5,w0,w1,w2,w3 --wait-workers w0,w1,w2,w3 >> logs/adapted.out 2>&1
stopped && { log stopped; exit 0; }
log "adapted done"
python3 "$T/adapted.py" --retry --model opus --cap 50 --workers w4,w5,w0,w1 >> logs/adapted_retry.out 2>&1
stopped && { log stopped; exit 0; }
log "retry done"
python3 "$T/anchor.py" --parallel 4 >> logs/anchor.out 2>&1
python3 "$T/strict.py" >> logs/strict.out 2>&1
log "anchor+strict done"
python3 "$T/repro.py" --cap 60 --workers w4,w5,w0,w1 --filter state/strict.json >> logs/repro.out 2>&1
python3 "$T/repro.py" --cap 60 --workers w4,w5,w0,w1 >> logs/repro.out 2>&1
python3 "$T/strict.py" >> logs/strict.out 2>&1
log "chain done"
