#!/bin/bash
for i in 0 1 2; do
  p=$((PORT+i))
  mkdir -p n$i
  "$VALKEY_SERVER" --port $p --cluster-enabled yes --cluster-config-file nodes.conf --save "" --appendonly no --dir n$i --logfile s.log &
done
for i in 0 1 2; do
  until "$VALKEY_CLI" -p $((PORT+i)) ping >/dev/null 2>&1; do sleep 0.1; done
done
"$VALKEY_CLI" -p $PORT cluster addslotsrange 0 5460 >/dev/null
"$VALKEY_CLI" -p $((PORT+1)) cluster addslotsrange 5461 10922 >/dev/null
"$VALKEY_CLI" -p $((PORT+2)) cluster addslotsrange 10923 16383 >/dev/null
"$VALKEY_CLI" -p $PORT cluster meet 127.0.0.1 $((PORT+1)) >/dev/null
"$VALKEY_CLI" -p $PORT cluster meet 127.0.0.1 $((PORT+2)) >/dev/null
for i in 0 1 2; do
  until "$VALKEY_CLI" -p $((PORT+i)) cluster info | grep -q "cluster_state:ok" &&
        [ "$("$VALKEY_CLI" -p $((PORT+i)) cluster info | grep -c .)" -gt 0 ] &&
        "$VALKEY_CLI" -p $((PORT+i)) cluster info | grep -q "cluster_known_nodes:3"; do sleep 0.2; done
done
"$VALKEY_CLI" -p $PORT publish hello world
"$VALKEY_CLI" -p $PORT cluster info | grep cluster_stats_messages_publish_sent | tr -d '\r'
for i in 0 1 2; do "$VALKEY_CLI" -p $((PORT+i)) shutdown nosave >/dev/null 2>&1; done
wait
