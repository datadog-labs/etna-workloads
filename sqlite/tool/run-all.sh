#!/bin/bash
# Run every stage after mine and base, unattended, for the target in env.sh:
# verbatim, triage, adapted agents, anchor, reproducers. Each stage resumes
# where a previous run stopped. Agent spend is capped per stage.
#
#   cd ~/<target>-etna && nohup tool/run-all.sh > logs/run-all.out 2>&1 &
#
# Progress: logs/run-all.log (one line per stage) and logs/<stage>.log.
# Done: logs/run-all.done.
set -u
cd "$(dirname "$0")/.."
source ./env.sh
mkdir -p logs
ADAPT_BUDGET=${ADAPT_BUDGET:-100}
REPRO_BUDGET=${REPRO_BUDGET:-40}
ADAPT_SINCE=${ADAPT_SINCE:-0}
JOBS=${JOBS:-8}          # parallel candidates/agents; lower it for heavy builds (Go)
REPRO=tool/repro.py
[ "${ETNA_KIND:-sqlite}" = valkey ] && REPRO=tool/repro_valkey.py
[ "${ETNA_KIND:-sqlite}" = cpython ] && REPRO=tool/repro_cpython.py
[ "${ETNA_KIND:-sqlite}" = go ] && REPRO=tool/repro_go.py
[ "${ETNA_KIND:-sqlite}" = datafusion ] && REPRO=tool/repro_datafusion.py

log() { echo "$(date -u +%FT%TZ) $*" | tee -a logs/run-all.log; }
stage() {   # stage <name> <command...>
  local name=$1; shift
  log "start $name"
  if "$@" > "logs/$name.log" 2>&1; then log "done $name: $(tail -1 "logs/$name.log")"
  else log "FAILED $name (exit $?): $(tail -3 "logs/$name.log" | tr '\n' ' ')"; fi
}

rm -f logs/run-all.done
stage verbatim python3 tool/sqlite_etna.py verbatim -j "$JOBS" --jobs-per 2
stage triage   python3 tool/triage.py -j 8
stage triage2  python3 tool/triage.py -j 6 --batch 10            # batches that failed to parse
stage adapt    python3 tool/adapt.py run -j "$JOBS" --tag sonnet --model claude-sonnet-5-5 --bugs-only --budget "$ADAPT_BUDGET" --since "$ADAPT_SINCE"
stage anchor   python3 tool/adapt.py anchor -j "$JOBS" --tag sonnet
[ -n "$REPRO" ] && stage repro python3 "$REPRO" run -j "$JOBS" --budget "$REPRO_BUDGET"
log "all stages finished"
touch logs/run-all.done
