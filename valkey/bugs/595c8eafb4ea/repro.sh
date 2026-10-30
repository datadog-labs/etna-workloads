#!/bin/bash
P1=$PORT; P2=$((PORT+1)); P3=$((PORT+2))
for p in $P1 $P2 $P3; do
  mkdir -p d$p
  "$VALKEY_SERVER" --port $p --cluster-enabled yes --cluster-config-file nodes.conf \
    --save "" --appendonly no --dir d$p --logfile s.log --cluster-node-timeout 1000 >/dev/null 2>&1 &
done
for p in $P1 $P2 $P3; do
  until "$VALKEY_CLI" -p $p ping >/dev/null 2>&1; do sleep 0.1; done
done
"$VALKEY_CLI" -p $P1 cluster addslotsrange 0 8191 >/dev/null
"$VALKEY_CLI" -p $P2 cluster addslotsrange 8192 16383 >/dev/null
"$VALKEY_CLI" -p $P1 cluster meet 127.0.0.1 $P2 >/dev/null
"$VALKEY_CLI" -p $P1 cluster meet 127.0.0.1 $P3 >/dev/null
for i in $(seq 100); do
  [ "$("$VALKEY_CLI" -p $P1 cluster info | grep -c 'cluster_state:ok')" = 1 ] &&
  [ "$("$VALKEY_CLI" -p $P3 cluster nodes | wc -l)" = 3 ] && break
  sleep 0.1
done
sleep 1
ID3=$("$VALKEY_CLI" -p $P3 cluster myid)
echo "--- del-node reachable empty node"
"$VALKEY_CLI" --cluster del-node 127.0.0.1:$P1 $ID3 2>&1 | grep -E 'ERR|OK\]' | sed -E 's/[0-9a-f]{40}/ID/'
echo "exit: ${PIPESTATUS[0]}"
"$VALKEY_CLI" -p $P1 cluster nodes | wc -l
for p in $P1 $P2 $P3; do "$VALKEY_CLI" -p $p shutdown nosave >/dev/null 2>&1; done
wait
