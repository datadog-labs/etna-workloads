#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log \
  --cluster-enabled yes --cluster-config-file nodes.conf &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" cluster addslotsrange 0 16383 >/dev/null
sleep 1
"$VALKEY_CLI" -p "$PORT" cluster slots >/dev/null
NEW=$((PORT+2))
"$VALKEY_CLI" -p "$PORT" config set port $NEW
"$VALKEY_CLI" -p "$NEW" cluster nodes | grep -c ":$NEW@"
"$VALKEY_CLI" -p "$NEW" cluster slots | grep -c "^$NEW$"
"$VALKEY_CLI" -p "$NEW" shutdown nosave
wait
