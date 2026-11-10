#!/bin/bash
# Full unattended chain (resumable: every stage skips work already recorded).
# Caps (approved): triage $5, adapted $170 (Sonnet 5.5), adapted-retry $40 (Opus 5.5),
# repro $60 (Sonnet 5.5); verbatim and anchors are compute only.
set -uo pipefail
T=$HOME/node-etna/tools
D=$HOME/node-etna/data
S=$HOME/node-etna-work/slots
L=$HOME/node-etna-work/logs/chain
mkdir -p "$L"
cd "$T"
log() { echo "[$(date -u +%FT%TZ)] $*" | tee -a "$L/chain.log"; }

# Stage 0: wait for an already-running verbatim gate (started before approval), then
# check all slots are pristine and make sure the third agent slot exists.
while pgrep -f "gate.py --inp ../data/candidates_units.jsonl" >/dev/null; do sleep 60; done
python3 checkslots.py >> "$L/chain.log" 2>&1
[ -d "$S/a3" ] || "$T/mkslot.sh" a3 >> "$L/chain.log" 2>&1

# Stage 1: triage (already complete; resumable no-op otherwise)
log "triage"
python3 triage.py --repo ~/node-etna-work/node --inp $D/candidates_probe.jsonl --out $D/triage.jsonl \
  --ledger $D/ledger.jsonl --cap-usd 5 -j 8 >> "$L/triage.log" 2>&1

# Stage 2: verbatim (slot r3) in parallel with adapted pass 1 (conflict candidates).
log "verbatim + adapted pass 1"
python3 gate.py --inp $D/candidates_units.jsonl --base $D/base_runs.json --out $D/verbatim.jsonl \
  --slots $S/r3 >> "$L/verbatim.log" 2>&1 &
VPID=$!
python3 adapted.py --inp $D/candidates_units.jsonl --triage $D/triage.jsonl --verbatim $D/verbatim.jsonl \
  --base $D/base_runs.json --out $D/adapted.jsonl --ledger $D/ledger.jsonl --cap-usd 170 \
  --agent-slots $S/a1,$S/a2,$S/a3 --gate-slots $S/r1,$S/r2 >> "$L/adapted1.log" 2>&1
wait $VPID
python3 checkslots.py >> "$L/chain.log" 2>&1

# Stage 3: adapted pass 2 (candidates whose verbatim reversal applied but did not fail/build).
log "adapted pass 2"
python3 adapted.py --inp $D/candidates_units.jsonl --triage $D/triage.jsonl --verbatim $D/verbatim.jsonl \
  --base $D/base_runs.json --out $D/adapted.jsonl --ledger $D/ledger.jsonl --cap-usd 170 \
  --agent-slots $S/a1,$S/a2,$S/a3 --gate-slots $S/r1,$S/r2,$S/r3 >> "$L/adapted2.log" 2>&1
python3 checkslots.py >> "$L/chain.log" 2>&1

# Stage 4: Opus retries of failures that could still become strict.
log "adapted retries (opus)"
python3 adapted.py --inp $D/candidates_units.jsonl --triage $D/triage.jsonl --verbatim $D/verbatim.jsonl \
  --base $D/base_runs.json --out $D/adapted_retry.jsonl --ledger $D/ledger.jsonl --cap-usd 40 \
  --stage adapted-retry --model claude-opus-5-5 --agent-budget 6 --retry-of $D/adapted.jsonl \
  --agent-slots $S/a1,$S/a2,$S/a3 --gate-slots $S/r1,$S/r2,$S/r3 \
  --logroot ~/node-etna-work/agentlogs/adapted-retry >> "$L/adapted-retry.log" 2>&1
python3 checkslots.py >> "$L/chain.log" 2>&1

# Stage 5: anchors (all adapted passes; strict-capable first) in parallel with reproducers.
log "anchors + reproducers"
python3 build_bugs.py --cands $D/candidates_units.jsonl --verbatim $D/verbatim.jsonl \
  --adapted $D/adapted.jsonl $D/adapted_retry.jsonl --out $D/bugs_gated.jsonl >> "$L/chain.log" 2>&1
python3 anchor.py --adapted $D/adapted.jsonl $D/adapted_retry.jsonl --cands $D/candidates_units.jsonl \
  --out $D/anchors.jsonl >> "$L/anchors.log" 2>&1 &
APID=$!
python3 repro.py --bugs $D/bugs_gated.jsonl --out $D/repro.jsonl --ledger $D/ledger.jsonl --cap-usd 60 \
  --agent-slots $S/a1,$S/a2,$S/a3 --gate-slots $S/r1,$S/r2,$S/r3 >> "$L/repro.log" 2>&1
wait $APID
python3 checkslots.py >> "$L/chain.log" 2>&1
log "chain done"
