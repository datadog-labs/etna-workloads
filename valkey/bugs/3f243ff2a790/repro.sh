#!/bin/bash
A=$PORT; B=$((PORT+1))
for p in $A $B; do
  mkdir -p n$p
  "$VALKEY_SERVER" --port $p --cluster-enabled yes --cluster-config-file nodes.conf --save "" --appendonly no --dir n$p --logfile s.log &
done
for p in $A $B; do
  until "$VALKEY_CLI" -p $p ping >/dev/null 2>&1; do sleep 0.1; done
done
cli() { p=$1; shift; "$VALKEY_CLI" -p $p "$@"; }
cli $A cluster addslotsrange 0 8191 >/dev/null
cli $B cluster addslotsrange 8192 16383 >/dev/null
cli $A cluster meet 127.0.0.1 $B >/dev/null
for i in $(seq 100); do
  [ "$(cli $A cluster info | grep -c cluster_state:ok)" = 1 ] && [ "$(cli $B cluster info | grep -c cluster_state:ok)" = 1 ] && break
  sleep 0.1
done
slot=$(cli $A cluster keyslot x)
echo "slot $slot"
for i in $(seq 100); do cli $B set "k$i{x}" v >/dev/null; done
echo "B dbsize before: $(cli $B dbsize)"
idA=$(cli $A cluster myid)
cli $B cluster migrateslots slotsrange $slot $slot node $idA
for i in $(seq 100); do
  [ "$(cli $A cluster countkeysinslot $slot)" = 100 ] && [ "$(cli $B dbsize)" = 0 ] && break
  sleep 0.1
done
echo "A countkeysinslot: $(cli $A cluster countkeysinslot $slot)"
echo "A dbsize: $(cli $A dbsize)"
echo "B dbsize: $(cli $B dbsize)"
cli $A shutdown nosave >/dev/null 2>&1
cli $B shutdown nosave >/dev/null 2>&1
wait
