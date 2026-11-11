#!/bin/sh
# Exit when the chain log changes (a stage boundary), when available memory drops
# below 8 GB, when free disk drops below 30 GB, or after $1 seconds.
# Only sleeps and reads small files (chain log, /proc/meminfo, df).
L=$HOME/ocaml-etna-work/logs/chain.log
start=$(wc -l < "$L" 2>/dev/null); t=0
while [ $t -lt "${1:-10800}" ]; do
  sleep 120; t=$((t+120))
  [ "$(wc -l < "$L" 2>/dev/null)" != "$start" ] && { tail -2 "$L"; exit 0; }
  avail=$(awk '/^MemAvailable/ {print int($2/1048576)}' /proc/meminfo)
  [ "$avail" -lt 8 ] && { echo "LOW MEMORY: ${avail} GB available"; exit 0; }
  disk=$(df -Pk "$HOME/ocaml-etna-work" | awk 'NR==2 {print int($4/1048576)}')
  [ "$disk" -lt 30 ] && { echo "LOW DISK: ${disk} GB free"; exit 0; }
done
echo "timeout; still at: $(tail -1 "$L" 2>/dev/null)"
