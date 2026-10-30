#!/bin/bash
R2=$((PORT+1))
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly yes --repl-diskless-sync-delay 0 --dir . --logfile m.log &
mkdir -p r
"$VALKEY_SERVER" --port "$R2" --save "" --appendonly yes --appendfsync always --dir r --logfile r.log &
RPID=$!
for p in $PORT $R2; do until "$VALKEY_CLI" -p $p ping >/dev/null 2>&1; do sleep 0.1; done; done
"$VALKEY_CLI" -p $R2 replicaof 127.0.0.1 $PORT
until [ "$("$VALKEY_CLI" -p $R2 info replication | grep -c master_link_status:up)" = 1 ]; do sleep 0.1; done
kill -STOP $RPID
printf "incr foo\nwaitaof 0 1 0\n" | "$VALKEY_CLI" -p $PORT > o1.txt &
printf "incr foo\nwaitaof 0 1 0\n" | "$VALKEY_CLI" -p $PORT > o2.txt &
until [ "$("$VALKEY_CLI" -p $PORT info clients | tr -d '\r' | sed -n 's/^blocked_clients://p')" = 2 ]; do sleep 0.1; done
kill -CONT $RPID
wait %3 %4
echo "total reply lines (expect 6):"; cat o1.txt o2.txt | wc -l
"$VALKEY_CLI" -p $R2 shutdown nosave
"$VALKEY_CLI" -p $PORT shutdown nosave
wait
