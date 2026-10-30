#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --cluster-enabled yes --enable-debug-command yes &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
C="$VALKEY_CLI -p $PORT"
$C cluster addslotsrange 0 16383 >/dev/null
sleep 1
$C debug cluster-publish-message-limit 32
$C publish ch xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
$C spublish ch xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
$C debug cluster-publish-message-limit 0
$C publish ch hello
$C shutdown nosave
wait
