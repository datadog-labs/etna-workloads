#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" eval 'redis.call("set", "key", "12039611435714932082"); return redis.call("get", "key")' 1 key
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait
