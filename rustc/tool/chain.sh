#!/bin/bash
# Full unattended run (approved caps: adapted $200, Opus retries $50, reproducer agents $30).
# Every step is resumable: rerunning this script skips finished work.
# START=B skips phase A (verbatim + slot creation); START=D runs only the reproducer stage.
# A stage that stops abnormally (slot broken, infrastructure error, low disk) stops the
# chain instead of letting the later stages run on a broken host.
set -u
cd ~/rustc-etna
LOG=~/rustc-etna-work/chain
mkdir -p "$LOG"
SLOTS=0,1,2,3,4,5
START=${START:-A}
stamp() { echo "$(date -u +%FT%TZ) $*" >> "$LOG/chain.log"; }
# Memory watchdog first: heavy jobs do not start without its heartbeat (tools/memguard.py).
if ! pgrep -u "$USER" -f '^python3 tools/memwatch.py$' > /dev/null; then
  setsid nohup python3 tools/memwatch.py >> "$LOG/memwatch.out" 2>&1 < /dev/null &
  stamp "memwatch started"
fi
healthy() {  # refuse to continue after infrastructure trouble
  if tail -50 "$1" | grep -qE 'SLOT BROKEN|INFRA ERROR|OS ERROR|Traceback'; then
    stamp "STOP: abnormal worker exit in $1"; exit 1
  fi
  local free=$(df --output=avail -B1G ~ | tail -1)
  if [ "$free" -lt 40 ]; then stamp "STOP: only ${free}G free"; exit 1; fi
}

if [ "$START" = A ]; then
  stamp "A: verbatim on 0,1,2; building slots 3-5"
  python3 tools/verbatim.py --slots 0,1,2 >> "$LOG/verbatim.log" 2>&1 &
  V=$!
  for n in 3 4 5; do
    [ -x ~/rustc-etna-work/slots/s$n/build/x86_64-unknown-linux-gnu/stage1/bin/rustc ] || python3 tools/slot.py create $n
  done >> "$LOG/slots.log" 2>&1
  wait $V
  healthy "$LOG/verbatim.log"
  stamp "A done"
fi

if [ "$START" = A ] || [ "$START" = B ]; then
stamp "B: adapted (Sonnet, cap 200, API errors re-run first) + anchors a0,a1"
rm -f data/.adapted_done
python3 tools/anchor.py --slot a0 --watch data/.adapted_done >> "$LOG/anchor-a0.log" 2>&1 &
A0=$!
python3 tools/anchor.py --slot a1 --watch data/.adapted_done >> "$LOG/anchor-a1.log" 2>&1 &
A1=$!
python3 tools/adapted.py --slots $SLOTS --cap 200 --retry-api-errors >> "$LOG/adapted.log" 2>&1
healthy "$LOG/adapted.log"
stamp "B adapted done"

stamp "C: Opus retries (cap 50), near-misses first"
python3 tools/adapted.py --slots $SLOTS --stage adapted-retry --model claude-opus-5-5 --cap 50 \
  --retry-statuses no_failure,build_failed,controls_failed >> "$LOG/adapted-retry.log" 2>&1
healthy "$LOG/adapted-retry.log"
python3 tools/adapted.py --slots $SLOTS --stage adapted-retry --model claude-opus-5-5 --cap 50 \
  --retry-statuses agent_gave_up >> "$LOG/adapted-retry.log" 2>&1
healthy "$LOG/adapted-retry.log"
touch data/.adapted_done
stamp "C done; waiting for anchors"
wait $A0 $A1
healthy "$LOG/anchor-a0.log"; healthy "$LOG/anchor-a1.log"
stamp "anchors done"

fi

if [ "$START" = D ]; then  # resume: anchors run alongside the reproducers
  stamp "D: anchors a0-a3 (resume)"
  ANCH=""
  for s in a0 a1 a2 a3; do
    python3 tools/anchor.py --slot $s --watch data/.adapted_done >> "$LOG/anchor-$s.log" 2>&1 &
    ANCH="$ANCH $!"
  done
fi

stamp "D: reproducers (agent cap 30 total)"
python3 tools/reproducers.py --tier adapted --slots $SLOTS --agent --cap 30 >> "$LOG/repro.log" 2>&1
healthy "$LOG/repro.log"
python3 tools/reproducers.py --tier verbatim --slots $SLOTS --agent --cap 30 >> "$LOG/repro.log" 2>&1
healthy "$LOG/repro.log"
stamp "D reproducers done"
if [ "$START" = D ]; then
  wait $ANCH
  for s in a0 a1 a2 a3; do healthy "$LOG/anchor-$s.log"; done
  stamp "anchors done"
fi
stamp "D done; chain complete"
