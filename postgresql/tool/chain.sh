#!/bin/sh
# Unattended full run (resumable; touch ~/pg-etna-work/STOP to stop between items).
# Caps (USD): adapted 150, adapted_retry 50, repro 60.  Triage already done (cap 5).
T=$(dirname "$0"); W=${ETNA_WORK:-$HOME/pg-etna-work}; cd "$W" || exit 1
log() { echo "$(date -Is) $*" >> "$W/logs/chain.log"; }
stopped() { [ -e "$W/STOP" ]; }
verbatim_running() { ps -eo args | grep -q '^python3 .*/verbatim.py candidates'; }
log "chain start"
python3 "$T/triage.py" candidates.jsonl 5 8 >> logs/triage.out 2>&1          # no-op if all triaged
# 1. adapted while verbatim finishes (2 agents on w4,w5)
if verbatim_running; then
  python3 "$T/adapted.py" --cap 150 --workers w4,w5 >> logs/adapted.out 2>&1 &
  AP=$!
  while verbatim_running; do sleep 120; done
  log "verbatim done"; wait $AP
fi
stopped && { log stopped; exit 0; }
python3 "$T/verbatim.py" candidates.jsonl probe_apply.jsonl 4 >> logs/verbatim.out 2>&1   # resume leftovers
# 2. adapted pass 2 (picks up verbatim no_failure etc.), 3 agents
python3 "$T/adapted.py" --cap 150 --workers w4,w5,w0 >> logs/adapted.out 2>&1
stopped && { log stopped; exit 0; }
log "adapted done"
# 3. retries with the largest model
python3 "$T/adapted.py" --retry --model opus --cap 50 --workers w4,w5,w0 >> logs/adapted_retry.out 2>&1
stopped && { log stopped; exit 0; }
log "retry done"
# 4. anchors, strict
python3 "$T/anchor.py" --parallel 3 >> logs/anchor.out 2>&1
python3 "$T/strict.py" >> logs/strict.out 2>&1
log "anchor+strict done"
# 5. reproducers: strict first, then the rest
python3 "$T/repro.py" --cap 60 --workers w4,w5,w0 --filter state/strict.json >> logs/repro.out 2>&1
python3 "$T/repro.py" --cap 60 --workers w4,w5,w0 >> logs/repro.out 2>&1
python3 "$T/strict.py" >> logs/strict.out 2>&1
log "chain done"
