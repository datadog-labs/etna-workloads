#!/bin/bash
P1=$PORT; P2=$((PORT+1))
mkdir -p n1 n2
for i in 1 2; do
  p=$((PORT+i-1))
  (cd n$i && "$VALKEY_SERVER" --port $p --cluster-enabled yes --cluster-config-file nodes.conf \
    --save "" --appendonly no --dir . --logfile s.log --hz 1 --enable-debug-command yes &) 
done
for p in $P1 $P2; do
  until "$VALKEY_CLI" -p $p ping >/dev/null 2>&1; do sleep 0.1; done
done
"$VALKEY_CLI" -p $P1 cluster addslotsrange 0 8191 >/dev/null
"$VALKEY_CLI" -p $P2 cluster addslotsrange 8192 16383 >/dev/null
"$VALKEY_CLI" -p $P2 cluster meet 127.0.0.1 $P1 >/dev/null
for i in $(seq 100); do
  "$VALKEY_CLI" -p $P1 cluster info | grep -q cluster_state:ok && \
  "$VALKEY_CLI" -p $P2 cluster info | grep -q cluster_state:ok && break
  sleep 0.2
done
for i in $(seq 1000); do echo "set {39296}k$i v$i"; done | "$VALKEY_CLI" -p $P2 -c >/dev/null
ID1=$("$VALKEY_CLI" -p $P1 cluster myid)
"$VALKEY_CLI" -p $P2 cluster countkeysinslot 16383
"$VALKEY_CLI" -p $P2 cluster migrateslots slotsrange 16383 16383 node $ID1
for i in $(seq 100); do
  [ "$("$VALKEY_CLI" -p $P1 cluster countkeysinslot 16383)" = 1000 ] && break
  sleep 0.2
done
"$VALKEY_CLI" -p $P1 cluster countkeysinslot 16383
"$VALKEY_CLI" -p $P2 cluster countkeysinslot 16383
for p in $P1 $P2; do "$VALKEY_CLI" -p $p shutdown nosave >/dev/null 2>&1; done
