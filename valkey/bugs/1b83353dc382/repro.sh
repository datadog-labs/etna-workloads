#!/bin/bash
S="$VALKEY_SERVER"; C="$VALKEY_CLI"; M=$PORT; R=$((PORT+1))
mkdir -p m r
"$S" --port $M --save "" --appendonly no --dir m --logfile m.log &
"$S" --port $R --save "" --appendonly no --dir r --logfile r.log &
for p in $M $R; do until "$C" -p $p ping >/dev/null 2>&1; do sleep 0.1; done; done
"$C" -p $R replicaof 127.0.0.1 $M
until "$C" -p $R info replication | grep -q master_link_status:up; do sleep 0.1; done
"$C" -p $M set foo bar >/dev/null
sleep 1
old=$("$C" -p $M info replication | grep ^master_repl_offset: | tr -d '\r' | cut -d: -f2)
"$C" -p $R client pause 100000 write
"$C" -p $M set foo2 bar2 >/dev/null
sleep 1
rr=$("$C" -p $R info replication | grep ^slave_read_repl_offset: | tr -d '\r' | cut -d: -f2)
ro=$("$C" -p $R info replication | grep ^slave_repl_offset: | tr -d '\r' | cut -d: -f2)
[ "$rr" != "$old" ] && echo "read offset advanced"
[ "$ro" == "$old" ] && echo "applied offset unchanged" || echo "applied offset grew"
"$C" -p $R shutdown nosave 2>/dev/null
"$C" -p $M shutdown nosave 2>/dev/null
wait
