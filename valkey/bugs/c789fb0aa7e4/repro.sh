#!/bin/bash
P1=$PORT; P2=$((PORT+1))
for p in $P1 $P2; do
  mkdir -p n$p
  (cd n$p && "$VALKEY_SERVER" --port $p --cluster-enabled yes --cluster-port $((p+10000)) --save "" --appendonly no --enable-debug-command yes --logfile s.log &) 
done
for p in $P1 $P2; do
  until "$VALKEY_CLI" -p $p ping >/dev/null 2>&1; do sleep 0.1; done
done
"$VALKEY_CLI" -p $P1 cluster addslotsrange 0 16383
"$VALKEY_CLI" -p $P1 cluster meet 127.0.0.1 $P2
for i in $(seq 100); do
  [ "$("$VALKEY_CLI" -p $P1 cluster nodes | wc -l)" = 2 ] && [ "$("$VALKEY_CLI" -p $P2 cluster nodes | wc -l)" = 2 ] && break
  sleep 0.1
done
for i in $(seq 100); do
  "$VALKEY_CLI" -p $P1 cluster info | grep -q cluster_state:ok && break
  sleep 0.1
done
"$VALKEY_CLI" -p $P1 debug set-active-expire 0
slot=$("$VALKEY_CLI" -p $P1 cluster keyslot FOO)
"$VALKEY_CLI" -p $P1 set FOO BAR PX 10
src=$("$VALKEY_CLI" -p $P1 cluster myid)
trg=$("$VALKEY_CLI" -p $P2 cluster myid)
"$VALKEY_CLI" -p $P1 cluster setslot $slot migrating $trg
"$VALKEY_CLI" -p $P2 cluster setslot $slot importing $src
sleep 0.5
"$VALKEY_CLI" -p $P1 get FOO | sed 's/[0-9.]\+:[0-9]\+/ADDR/'
"$VALKEY_CLI" -p $P1 ping
"$VALKEY_CLI" -p $P1 info stats | tr -d '\r' | grep '^expired_keys:'
"$VALKEY_CLI" -p $P1 dbsize
grep -q "ASSERTION FAILED" n$P1/s.log && echo ASSERTION
"$VALKEY_CLI" -p $P1 shutdown nosave >/dev/null 2>&1
"$VALKEY_CLI" -p $P2 shutdown nosave >/dev/null 2>&1
exit 0
