#!/bin/bash
# 3-node cluster; primary 0 loses a slot while paused by CLIENT PAUSE WRITE
S="$VALKEY_SERVER"; C="$VALKEY_CLI"
for i in 0 1 2; do
  p=$((PORT+i)); mkdir -p n$i
  "$S" --port $p --save "" --appendonly yes --dir n$i --logfile s.log \
    --cluster-enabled yes --cluster-config-file nodes.conf --cluster-node-timeout 3000 &
done
for i in 0 1 2; do
  until "$C" -p $((PORT+i)) ping >/dev/null 2>&1; do sleep 0.1; done
done
"$C" -p $PORT cluster addslotsrange 0 5460 >/dev/null
"$C" -p $((PORT+1)) cluster addslotsrange 5461 10922 >/dev/null
"$C" -p $((PORT+2)) cluster addslotsrange 10923 16383 >/dev/null
"$C" -p $PORT cluster meet 127.0.0.1 $((PORT+1)) >/dev/null
"$C" -p $PORT cluster meet 127.0.0.1 $((PORT+2)) >/dev/null
for i in 0 1 2; do
  until "$C" -p $((PORT+i)) cluster info | grep -q cluster_state:ok; do sleep 0.1; done
done
"$C" -p $PORT set FOO 0
"$C" -p $PORT client pause 1000000000 write
"$C" -p $((PORT+1)) cluster bumpepoch >/dev/null
slot=$("$C" -p $((PORT+1)) cluster keyslot FOO)
id=$("$C" -p $((PORT+1)) cluster myid)
"$C" -p $((PORT+1)) cluster setslot $slot node $id
for i in $(seq 100); do grep -q "Deleting keys in dirty slot" n0/s.log && break; sleep 0.1; done
sleep 0.5
"$C" -p $PORT ping
grep -q "ASSERTION FAILED" n0/s.log && echo ASSERTION
for i in 0 1 2; do "$C" -p $((PORT+i)) shutdown nosave >/dev/null 2>&1; done
wait
exit 0
