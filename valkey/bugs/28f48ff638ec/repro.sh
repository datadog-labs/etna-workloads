#!/bin/bash
R=$((PORT+1))
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile m.log &
"$VALKEY_SERVER" --port "$R" --save "" --appendonly no --dir . --logfile r.log --replicaof "127.0.0.1 $PORT" &
for p in "$PORT" "$R"; do
  until "$VALKEY_CLI" -p "$p" ping >/dev/null 2>&1; do sleep 0.1; done
done
for i in $(seq 100); do
  [ "$("$VALKEY_CLI" -p "$R" info replication | grep -c master_link_status:up)" = 1 ] && break
  sleep 0.1
done
"$VALKEY_CLI" -p "$PORT" set foo bar
"$VALKEY_CLI" -p "$PORT" delifeq foo bar
"$VALKEY_CLI" -p "$PORT" wait 1 5000 >/dev/null
echo "master exists: $("$VALKEY_CLI" -p "$PORT" exists foo)"
echo "replica exists: $("$VALKEY_CLI" -p "$R" exists foo)"
"$VALKEY_CLI" -p "$PORT" shutdown nosave 2>/dev/null
"$VALKEY_CLI" -p "$R" shutdown nosave 2>/dev/null
wait
