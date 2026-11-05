#!/bin/sh
# After the /dev/shm incident: wait for regate, redo all anchors, strict, then reproducers (shared $60 cap).
T=$(dirname "$0"); W=${ETNA_WORK:-$HOME/pg-etna-work}; cd "$W" || exit 1
log() { echo "$(date -Is) $*" >> "$W/logs/chain.log"; }
running() { ps -eo args | grep -q "^python3 .*/$1"; }
log "chain4 start"
while running regate.py; do sleep 120; done
log "regate done"
mkdir -p state/anchor_invalid_shm && mv state/anchor/*.json state/anchor_invalid_shm/ 2>/dev/null
python3 "$T/anchor.py" --parallel 6 --need-fix-added >> logs/anchor.out 2>&1
python3 "$T/strict.py" >> logs/strict.out 2>&1
log "anchor+strict done"
[ -e "$W/STOP" ] && { log stopped; exit 0; }
while running repro.py; do sleep 120; done
python3 "$T/repro.py" --cap 60 --workers w6,w7,w4,w5 --filter state/strict.json >> logs/repro.out 2>&1
python3 "$T/repro.py" --cap 60 --workers w6,w7,w4,w5 >> logs/repro.out 2>&1
python3 "$T/strict.py" >> logs/strict.out 2>&1
log "chain done"
