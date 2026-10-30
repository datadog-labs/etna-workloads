#!/bin/bash
# Failover must broadcast PONG so all nodes see the new role promptly.
C="$VALKEY_CLI"
P=($PORT $((PORT+1)) $((PORT+2)) $((PORT+3)))
for i in 0 1 2 3; do
  mkdir -p n$i
  "$VALKEY_SERVER" --port ${P[$i]} --cluster-enabled yes --cluster-config-file nodes.conf --cluster-node-timeout 1000 \
    --cluster-port $((PORT+10+i)) --save "" --appendonly no --dir n$i --logfile s.log --enable-debug-command yes >/dev/null &
done
for i in 0 1 2 3; do until "$C" -p ${P[$i]} ping >/dev/null 2>&1; do sleep 0.1; done; done
$C -p ${P[0]} cluster addslotsrange 0 5460 >/dev/null
$C -p ${P[1]} cluster addslotsrange 5461 10922 >/dev/null
$C -p ${P[2]} cluster addslotsrange 10923 16383 >/dev/null
for i in 1 2 3; do $C -p ${P[0]} cluster meet 127.0.0.1 ${P[$i]} $((PORT+10+i)) >/dev/null; done
until [ "$($C -p ${P[3]} cluster info | grep -c 'cluster_state:ok')" = 1 ] && [ "$($C -p ${P[0]} cluster nodes | grep -c connected)" = 4 ]; do sleep 0.2; done
id0=$($C -p ${P[0]} cluster myid); id3=$($C -p ${P[3]} cluster myid)
$C -p ${P[3]} cluster replicate $id0 >/dev/null
for t in $(seq 100); do [ "$($C -p ${P[0]} info replication | grep -c connected_slaves:1)" = 1 ] && break; sleep 0.2; done
sleep 2
for i in 0 1 2 3; do $C -p ${P[$i]} config set cluster-ping-interval 300000 >/dev/null; $C -p ${P[$i]} config set cluster-node-timeout 60000 >/dev/null; $C -p ${P[$i]} debug disable-cluster-random-ping 1 >/dev/null; done
sleep 1
$C -p ${P[3]} cluster failover >/dev/null
for t in $(seq 100); do $C -p ${P[3]} role | head -1 | grep -q master && break; sleep 0.1; done
for t in $(seq 100); do $C -p ${P[0]} role | head -1 | grep -q slave && break; sleep 0.1; done
$C -p ${P[0]} cluster failover
for t in $(seq 100); do $C -p ${P[0]} role | head -1 | grep -q master && break; sleep 0.1; done
sleep 1
echo "node0 role after second failover: $($C -p ${P[0]} role | head -1)"
echo "node3 role: $($C -p ${P[3]} role | head -1)"
for i in 0 1 2 3; do $C -p ${P[$i]} shutdown nosave >/dev/null 2>&1; done
wait
