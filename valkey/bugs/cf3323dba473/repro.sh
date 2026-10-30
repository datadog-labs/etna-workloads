#!/bin/bash
cat > r.conf <<C
port $PORT
save ""
appendonly no
dir .
logfile s.log
rename-command flushdb badger
C
"$VALKEY_SERVER" r.conf &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" config rewrite
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
"$VALKEY_SERVER" r.conf &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" flushdb
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
