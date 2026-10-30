#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --enable-debug-command yes --dir . --logfile s.log &
SPID=$!
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
C() { "$VALKEY_CLI" -p "$PORT" "$@"; }
C config set save "900 1"
C config set rdb-key-save-delay 10000000
C debug populate 1000 >/dev/null 2>&1
C set x x
C bgsave
sleep 1
kill -9 $(ps -o pid= --ppid $SPID)
sleep 1
C get x
# send write + ping in one pipeline; an extra CRLF in the error desyncs replies
printf 'SET x y\r\nPING\r\nPING\r\n' | C --no-raw 2>&1
C set x y
C ping
C shutdown nosave
wait
