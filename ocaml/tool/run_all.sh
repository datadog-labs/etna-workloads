#!/bin/sh
# Unattended, resumable chain. Each stage skips work already recorded in data/.
# Caps are per stage (USD, as reported by the claude CLI); they sum to <= BUDGET.
set -u
cd "$(dirname "$0")"
L=$HOME/ocaml-etna-work/logs; mkdir -p "$L"
: "${CAP_TRIAGE:=10}" "${CAP_ADAPTED:=170}" "${CAP_RETRY:=40}" "${CAP_REPRO:=80}"
export ETNA_JOBS=4
# START=<stage> resumes the chain at that stage (stages: verbatim triage adapted retry anchor repro report)
: "${START:=verbatim}"
order="verbatim triage adapted retry anchor repro report"
run_stage() { case " ${order#*$START} " in *" $1 "*|" ") return 0;; esac; [ "$1" = "$START" ]; }
run_stage verbatim && { echo "$(date) verbatim"   >> "$L/chain.log"; python3 verbatim.py --slots 3 --first-slot 1            >> "$L/verbatim.log" 2>&1; }
run_stage triage && { echo "$(date) triage"     >> "$L/chain.log"; python3 triage.py "$CAP_TRIAGE"                         >> "$L/triage.log" 2>&1; }
run_stage adapted && { echo "$(date) adapted"    >> "$L/chain.log"; python3 adapted.py --cap "$CAP_ADAPTED" --par 6 --first-slot 5 >> "$L/adapted.log" 2>&1; }
run_stage retry && { echo "$(date) retry"      >> "$L/chain.log"; python3 retry.py --cap "$CAP_RETRY" --par 3 --first-slot 5    >> "$L/retry.log" 2>&1; }
run_stage anchor && { echo "$(date) anchor"     >> "$L/chain.log"; python3 anchor.py --par 4                               >> "$L/anchor.log" 2>&1; }
run_stage repro && { echo "$(date) repro"      >> "$L/chain.log"; python3 repro.py --cap "$CAP_REPRO" --par 3 --first-slot 8 --strict-only >> "$L/repro.log" 2>&1; }
run_stage repro && { echo "$(date) repro-rest" >> "$L/chain.log"; python3 repro.py --cap "$CAP_REPRO" --par 3 --first-slot 8 >> "$L/repro.log" 2>&1; }
run_stage report && { echo "$(date) report"     >> "$L/chain.log"; python3 report.py > "$L/report.txt" 2>&1; }
echo "$(date) done"       >> "$L/chain.log"
