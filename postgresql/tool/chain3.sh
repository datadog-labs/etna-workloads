#!/bin/sh
# Final part of the run: anchors (only bugs that can be strict), strict classification, reproducers (cap $60).
T=$(dirname "$0"); W=${ETNA_WORK:-$HOME/pg-etna-work}; cd "$W" || exit 1
log() { echo "$(date -Is) $*" >> "$W/logs/chain.log"; }
log "chain3 start"
python3 "$T/anchor.py" --parallel 6 --need-fix-added >> logs/anchor.out 2>&1
python3 "$T/strict.py" >> logs/strict.out 2>&1
log "anchor+strict done"
[ -e "$W/STOP" ] && { log stopped; exit 0; }
python3 "$T/repro.py" --cap 60 --workers w4,w5,w0,w1 --filter state/strict.json >> logs/repro.out 2>&1
python3 "$T/repro.py" --cap 60 --workers w4,w5,w0,w1 >> logs/repro.out 2>&1
python3 "$T/strict.py" >> logs/strict.out 2>&1
log "chain done"
