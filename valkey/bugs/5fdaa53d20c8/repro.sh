#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" eval "local foo = redis.pcall('hincrby','hash','field',200000000) return {type(foo),foo}" 0
"$VALKEY_CLI" -p "$PORT" eval "redis.call('hincrby','hash','field',tonumber('1000000000')) return redis.call('hget','hash','field')" 0
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
