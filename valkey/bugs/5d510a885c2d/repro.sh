#!/bin/bash
C() { "$VALKEY_CLI" -p "$PORT" "$@"; }
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly yes --cluster-enabled yes --enable-debug-command yes --dir . --logfile s.log &
until C ping >/dev/null 2>&1; do sleep 0.1; done
C cluster addslotsrange 0 16383
until C cluster info | grep -q cluster_state:ok; do sleep 0.1; done
C set k0 a
C bgrewriteaof
while C info persistence | grep -q aof_rewrite_in_progress:1; do sleep 0.1; done
sleep 1
C set k1 b
printf 'MULTI\r\nSET k0 c\r\nAPPEND k0 d\r\nEXEC\r\n' | C
C debug loadaof
C dbsize
C get k0
C get k1
C shutdown nosave
wait
