#!/bin/bash
P2=$((PORT+1))
mkdir -p a b
for spec in "a $PORT" "b $P2"; do
  set -- $spec
  (cd $1 && "$VALKEY_SERVER" --port $2 --cluster-enabled yes --cluster-config-file n.conf --save "" --appendonly no --dir . --logfile s.log &) 
done
for p in $PORT $P2; do until "$VALKEY_CLI" -p $p ping >/dev/null 2>&1; do sleep 0.1; done; done
"$VALKEY_CLI" -p $PORT cluster addslotsrange 0 8000 >/dev/null
"$VALKEY_CLI" -p $P2 cluster addslotsrange 8001 16383 >/dev/null
"$VALKEY_CLI" -p $PORT cluster meet 127.0.0.1 $P2 >/dev/null
until "$VALKEY_CLI" -p $PORT cluster info | grep -q cluster_state:ok && "$VALKEY_CLI" -p $P2 cluster info | grep -q cluster_state:ok; do sleep 0.1; done
ID1=$("$VALKEY_CLI" -p $PORT cluster myid); ID2=$("$VALKEY_CLI" -p $P2 cluster myid)
"$VALKEY_CLI" -p $PORT xgroup create aga mygroup '$' mkstream
"$VALKEY_CLI" -p $PORT xreadgroup group mygroup consumer block 0 streams aga '>' >/dev/null 2>&1 &
BG=$!
until [ "$("$VALKEY_CLI" -p $PORT info clients | grep -c blocked_clients:1)" = 1 ]; do sleep 0.1; done
"$VALKEY_CLI" -p $PORT cluster setslot 609 migrating $ID2
"$VALKEY_CLI" -p $P2 cluster setslot 609 importing $ID1
"$VALKEY_CLI" -p $PORT migrate 127.0.0.1 $P2 aga 0 5000
sleep 1
"$VALKEY_CLI" -p $PORT ping
grep -q "ASSERTION FAILED" a/s.log && echo ASSERTION
kill $BG 2>/dev/null
"$VALKEY_CLI" -p $PORT shutdown nosave 2>/dev/null
"$VALKEY_CLI" -p $P2 shutdown nosave 2>/dev/null
exit 0
