#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@" 2>&1; }
c hset myhash a 1 b 2
for cmd in HTTL HPTTL HEXPIRETIME HPEXPIRETIME HPERSIST; do
  echo "$cmd:"; c $cmd myhash a 1 c
done
c hexpire myhash 100 FIELDS 1 a
c hpersist myhash a 1 a
c httl myhash a 1 a
c ttl myhash
c hpersist myhash FIELDS 1 a
c shutdown nosave
wait
