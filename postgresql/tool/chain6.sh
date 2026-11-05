#!/bin/sh
# Continue after anchors: strict, then reproducers with the raised cap ($90 total, user decision 2026-11-05).
T=$(dirname "$0"); W=${ETNA_WORK:-$HOME/pg-etna-work}; cd "$W" || exit 1
log() { echo "$(date -Is) $*" >> "$W/logs/chain.log"; }
running() { ps -eo args | grep -q "^python3 .*/$1"; }
log "chain6 start (repro cap 90)"
while running anchor.py; do sleep 120; done
python3 "$T/strict.py" >> logs/strict.out 2>&1
log "anchor+strict done"
[ -e "$W/STOP" ] && { log stopped; exit 0; }
while running repro.py; do sleep 120; done
python3 "$T/repro.py" --cap 90 --workers w6,w7,w4,w5 --filter state/strict.json >> logs/repro.out 2>&1
python3 "$T/repro.py" --cap 90 --workers w6,w7,w4,w5 >> logs/repro.out 2>&1
python3 "$T/strict.py" >> logs/strict.out 2>&1
log "chain done"
