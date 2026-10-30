#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
for i in 1 2 3 4 5; do c XADD x $i-0 data v >/dev/null; done
c XDEL x 3-0 >/dev/null
c XGROUP CREATE x g1 0 >/dev/null
c XGROUP CREATE x g2 0 >/dev/null
for i in 1 2 3 4; do c XREADGROUP GROUP g1 c1 COUNT 1 STREAMS x '>' >/dev/null; done
c XADD x 6-0 data v >/dev/null
c XADD x 7-0 data v >/dev/null
c XTRIM x MINID = 7-0
c XINFO STREAM x FULL | grep -A1 -E "^(entries-read|lag)$"
c XREADGROUP GROUP g1 c1 STREAMS x '>' >/dev/null
c XINFO STREAM x FULL | grep -A1 -E "^(entries-read|lag)$"
c shutdown nosave
wait
