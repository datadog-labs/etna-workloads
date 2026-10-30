#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@" 2>&1; }
args=(); for i in $(seq 128); do args+=(f$i v); done
f126=(); for i in $(seq 126); do f126+=(f$i); done
c hset myhash "${args[@]}" >/dev/null
c hpexpireat myhash 9223372036854767616 FIELDS 126 "${f126[@]}" | sort | uniq -c
c hpexpireat myhash 9223372036854775616 FIELDS 1 f127
c hpexpireat myhash 9223372036854767616 FIELDS 1 f128
c ping
c hlen myhash
grep -q "ASSERTION FAILED" s.log && echo ASSERTION
c shutdown nosave >/dev/null
wait
