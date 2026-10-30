#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c XADD mystream 1-0 f v
c XADD mystream 1641544570597-0 f v
c XADD mystream 1641544570597-1 f v
c XTRIM mystream MINID 1641544570597-0
c XRANGE mystream - +
c shutdown nosave
wait
