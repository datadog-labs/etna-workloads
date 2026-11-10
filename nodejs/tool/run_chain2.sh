#!/bin/bash
# Remaining chain after the user's 2026-11-04 decisions (replaces stages 3-5 of run_chain.sh).
# Caps: adapted pass 2 $80 (own ledger stage "adapted-pass2"), adapted-retry $40 (Opus 5.5),
# repro $60.  Anchors: all accepted adapted bugs, strict-capable first; they run in their own
# process group (pid in $W/anchor.pid) and keep going after this script ends.
# Waits use exact PIDs (never pgrep -f patterns).
set -uo pipefail
T=$HOME/node-etna/tools
D=$HOME/node-etna/data
W=$HOME/node-etna-work
S=$W/slots
L=$W/logs/chain
cd "$T"
log() { echo "[$(date -u +%FT%TZ)] $*" | tee -a "$L/chain.log"; }
wait_pid() { while [ -e "/proc/$1" ]; do sleep 30; done; }

log "chain2: waiting for adapted pass 1 (pid $1) and verbatim re-gate (pid $2)"
wait_pid "$1"
wait_pid "$2"
python3 checkslots.py >> "$L/chain.log" 2>&1

log "adapted pass 2 (verbatim reversals that apply but do not build / do not fail)"
python3 adapted.py --inp $D/candidates_units.jsonl --triage $D/triage.jsonl --verbatim $D/verbatim.jsonl \
  --base $D/base_runs.json --out $D/adapted.jsonl --ledger $D/ledger.jsonl --cap-usd 80 \
  --stage adapted-pass2 --verbatim-failures-only \
  --agent-slots $S/a1,$S/a2,$S/a3 --gate-slots $S/r1,$S/r2,$S/r3 \
  --logroot $W/agentlogs/adapted-pass2 >> "$L/adapted2.log" 2>&1
python3 checkslots.py >> "$L/chain.log" 2>&1

log "adapted retries (opus)"
python3 adapted.py --inp $D/candidates_units.jsonl --triage $D/triage.jsonl --verbatim $D/verbatim.jsonl \
  --base $D/base_runs.json --out $D/adapted_retry.jsonl --ledger $D/ledger.jsonl --cap-usd 40 \
  --stage adapted-retry --model claude-opus-5-5 --agent-budget 6 --retry-of $D/adapted.jsonl \
  --agent-slots $S/a1,$S/a2,$S/a3 --gate-slots $S/r1,$S/r2,$S/r3 \
  --logroot $W/agentlogs/adapted-retry >> "$L/adapted-retry.log" 2>&1
python3 checkslots.py >> "$L/chain.log" 2>&1

log "anchors (background, own process group) + reproducers"
python3 build_bugs.py --cands $D/candidates_units.jsonl --verbatim $D/verbatim.jsonl \
  --adapted $D/adapted.jsonl $D/adapted_retry.jsonl --out $D/bugs_gated.jsonl >> "$L/chain.log" 2>&1
setsid python3 anchor.py --adapted $D/adapted.jsonl $D/adapted_retry.jsonl \
  --cands $D/candidates_units.jsonl --out $D/anchors.jsonl >> "$L/anchors.log" 2>&1 < /dev/null &
echo $! > "$W/anchor.pid"
log "anchor pid $(cat $W/anchor.pid)"
python3 repro.py --bugs $D/bugs_gated.jsonl --out $D/repro.jsonl --ledger $D/ledger.jsonl --cap-usd 60 \
  --agent-slots $S/a1,$S/a2,$S/a3 --gate-slots $S/r1,$S/r2,$S/r3 >> "$L/repro.log" 2>&1
python3 checkslots.py >> "$L/chain.log" 2>&1
log "chain2 done (anchors continue in pid $(cat $W/anchor.pid))"
