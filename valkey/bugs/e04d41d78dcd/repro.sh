#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
C() { "$VALKEY_CLI" -p "$PORT" "$@"; }
{
for j in $(seq 1 300); do
  echo "eval \"return server.error_reply(string.format('%s my error message', ARGV[1]))\" 0 $j"
done
} | C >/dev/null
echo "overflow: $(C info errorstats | grep -c ERRORSTATS_OVERFLOW)"
echo "errorstat entries <= 129: $([ "$(C info errorstats | grep -c '^errorstat_')" -le 129 ] && echo yes || echo no)"
C shutdown nosave
wait
