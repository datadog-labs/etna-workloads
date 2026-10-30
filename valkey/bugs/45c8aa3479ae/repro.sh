#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c rpush mylist a b >/dev/null
for idx in 4294967295 4294967296 -4294967296 -4294967297; do
  echo "lset $idx: $(c lset mylist $idx changed)"
  echo "list: $(c lrange mylist 0 -1 | tr '\n' ' ')"
done
c shutdown nosave >/dev/null 2>&1
wait
