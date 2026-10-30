#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" set x 0
"$VALKEY_CLI" -p "$PORT" decrby x -9223372036854775808
"$VALKEY_CLI" -p "$PORT" get x
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
