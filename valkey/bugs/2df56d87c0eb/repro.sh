#!/bin/bash
P0=$PORT; P1=$((PORT+1)); P2=$((PORT+2))
for i in 0 1 2; do
  "$VALKEY_SERVER" --port $((PORT+i)) --save "" --appendonly no --dir . --logfile s$i.log \
    --cluster-enabled yes --cluster-config-file nodes$i.conf --cluster-node-timeout 1000 \
    --cluster-migration-barrier 999 --cluster-port $((PORT+10+i)) >/dev/null 2>&1 &
done
for i in 0 1 2; do
  until "$VALKEY_CLI" -p $((PORT+i)) ping >/dev/null 2>&1; do sleep 0.1; done
done
C() { local p=$1; shift; "$VALKEY_CLI" -p $p "$@"; }
C $P0 cluster addslotsrange 1 8192 >/dev/null
C $P1 cluster addslotsrange 8193 16383 >/dev/null
C $P2 cluster addslots 0 >/dev/null
C $P1 cluster meet 127.0.0.1 $P0 $((P0+10)) >/dev/null
C $P2 cluster meet 127.0.0.1 $P0 $((P0+10)) >/dev/null
for i in 0 1 2; do
  until C $((PORT+i)) cluster info | grep -q cluster_state:ok; do sleep 0.1; done
done
C $P2 config set cluster-allow-replica-migration no
C $P2 incr key_977613
C $P0 cluster bumpepoch >/dev/null
C $P0 cluster setslot 0 node "$(C $P0 cluster myid)"
for i in $(seq 100); do grep -q "I am now an empty primary" s2.log && break; sleep 0.1; done
sleep 1
echo "dbsize: $(C $P2 dbsize)"
for i in 0 1 2; do C $((PORT+i)) shutdown nosave >/dev/null 2>&1; done
wait
