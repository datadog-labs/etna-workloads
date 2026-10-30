#!/bin/bash
P=$PORT
R=$((PORT+1))
"$VALKEY_SERVER" --port $P --save "" --appendonly no --dir . --logfile p.log --repl-backlog-size 1MB &
PPID_=$!
mkdir -p r
"$VALKEY_SERVER" --port $R --save "" --appendonly no --dir r --logfile r.log --repl-backlog-size 1MB &
RPID=$!
for p in $P $R; do until "$VALKEY_CLI" -p $p ping >/dev/null 2>&1; do sleep 0.1; done; done

exec 3<>/dev/tcp/127.0.0.1/$P
printf 'BLPOP key 0.1\r\n' >&3
read -r -t 5 -u 3 line   # *-1 after timeout
sleep 0.3

"$VALKEY_CLI" -p $R replicaof 127.0.0.1 $P
until "$VALKEY_CLI" -p $R info replication | grep -q master_link_status:up; do sleep 0.1; done

kill -STOP $RPID
"$VALKEY_CLI" -p $P incr k
printf 'SHUTDOWN\r\n' >&3
sleep 1
"$VALKEY_CLI" -p $P info clients | grep -E 'connected_clients|blocked_clients' | tr -d '\r'
kill -CONT $RPID
exec 3>&-
sleep 2
grep -q "BUG REPORT START" p.log && echo CRASH
"$VALKEY_CLI" -p $P ping 2>&1 | head -1
"$VALKEY_CLI" -p $R shutdown nosave >/dev/null 2>&1
"$VALKEY_CLI" -p $P shutdown nosave >/dev/null 2>&1
wait
