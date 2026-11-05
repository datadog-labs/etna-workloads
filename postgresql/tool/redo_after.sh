#!/bin/sh
# Wait for the main adapted pass (PID $1) to exit, then redo API-error candidates with sonnet on w2,w3.
T=$(cd "$(dirname "$0")" && pwd)
while kill -0 "$1" 2>/dev/null; do sleep 60; done
cd "${ETNA_WORK:-$HOME/pg-etna-work}" && python3 "$T"/adapted.py --only "$(cat state/api_error_redo.txt)" --model sonnet \
  --stage adapted_retry --cap 50 --workers w2,w3 >> logs/adapted_redo.out 2>&1
echo "$(date -Is) api-error redo done" >> logs/chain.log
