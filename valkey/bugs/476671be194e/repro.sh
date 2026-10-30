#!/bin/bash
S="$VALKEY_SERVER"; C="$VALKEY_CLI"
P0=$PORT; P1=$((PORT+1)); P2=$((PORT+2)); P3=$((PORT+3))
for i in 0 1 2 3; do
  mkdir -p n$i
  "$S" --port $((PORT+i)) --cluster-enabled yes --cluster-node-timeout 3000 --cluster-replica-validity-factor 0 \
    --cluster-replica-no-failover yes --enable-debug-command yes --save "" --appendonly no \
    --dir n$i --logfile s.log --loglevel verbose >/dev/null 2>&1 &
  [ $i = 0 ] && PID0=$!
done
for p in $P0 $P1 $P2 $P3; do
  until "$C" -p $p ping >/dev/null 2>&1; do sleep 0.1; done
done
c() { local p=$1; shift; "$C" -p $p "$@"; }
for i in 0 1 2 3; do c $((PORT+i)) cluster set-config-epoch $((i+1)) >/dev/null; done
c $P0 cluster addslotsrange 0 5460 >/dev/null
c $P1 cluster addslotsrange 5461 10922 >/dev/null
c $P2 cluster addslotsrange 10923 16383 >/dev/null
for p in $P1 $P2 $P3; do c $p cluster meet 127.0.0.1 $P0 >/dev/null; done
id0=$(c $P0 cluster myid)
until [ "$(c $P3 cluster info | grep -c cluster_state:ok)" = 1 ] ; do sleep 0.2; done
until [ "$(c $P3 cluster nodes | grep -c connected)" = 4 ]; do sleep 0.2; done
c $P3 cluster replicate $id0 >/dev/null
sleep 2
c $P3 debug drop-cluster-packet-filter -2 >/dev/null
c $P3 debug close-cluster-link-on-packet-drop 1 >/dev/null
# make sure primary 0 has the smallest epoch so bumpepoch works
res=$(c $P0 cluster bumpepoch); ep=${res#BUMPED }
echo "bump: ${res%% *}"
for p in $P1 $P2; do
  for t in $(seq 100); do
    c $p cluster nodes | grep "^$id0" | grep -q " $ep " && break; sleep 0.1
  done
done
c $P3 cluster nodes | grep "^$id0" | grep -q " $ep " && echo "replica already updated" || echo "replica epoch stale"
kill -STOP $PID0
c $P3 debug drop-cluster-packet-filter -1 >/dev/null
c $P3 debug close-cluster-link-on-packet-drop 0 >/dev/null
for t in $(seq 250); do
  [ "$(c $P3 cluster info | grep -c cluster_state:fail)" = 1 ] && break; sleep 0.1
done
# keep trying a forced failover until the replica gets promoted or we give up
promoted=no
for t in $(seq 4); do
  c $P3 config set cluster-replica-no-failover yes >/dev/null
  c $P3 cluster failover force >/dev/null 2>&1
  for u in $(seq 25); do
    [ "$(c $P3 role | head -1)" = master ] && { promoted=yes; break; }; sleep 0.2
  done
  [ $promoted = yes ] && break
done
echo "replica promoted: $promoted"
kill -CONT $PID0
for p in $P1 $P2 $P3 $P0; do c $p shutdown nosave >/dev/null 2>&1; done
wait
