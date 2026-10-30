#!/bin/bash
S="$VALKEY_SERVER"; C="$VALKEY_CLI"; P=$PORT; R=$((PORT+1))
mkdir -p p r
"$S" --port $P --save "" --appendonly no --dir p --logfile p.log --enable-debug-command yes --repl-diskless-sync-delay 0 &
"$S" --port $R --save "" --appendonly no --dir r --logfile r.log &
for i in $(seq 100); do "$C" -p $P ping >/dev/null 2>&1 && "$C" -p $R ping >/dev/null 2>&1 && break; sleep 0.1; done
rc() { "$C" -p $R "$@"; }
pc() { "$C" -p $P "$@"; }
big=$(head -c 1000000 /dev/zero | tr '\0' x)
rc replicaof 127.0.0.1 $P >/dev/null
sync_wait() { for i in $(seq 200); do rc info replication | grep -q master_link_status:up && return; sleep 0.1; done; }
sync_wait
rc config set hz 500 >/dev/null
for j in $(seq 12); do
  pc debug change-repl-id >/dev/null
  rc replicaof no one >/dev/null
  rc replicaof 127.0.0.1 $P >/dev/null
  sync_wait
  echo "set foo $big" | pc -x set foo >/dev/null
  for i in $(seq 200); do [ "$(pc info replication | grep -m1 master_repl_offset | tr -d '\r')" = "$(rc info replication | grep -m1 master_repl_offset | tr -d '\r')" ] && break; done
done
sleep 3
m=$(rc info memory | grep mem_clients_normal | cut -d: -f2 | tr -d '\r')
if [ "$m" -lt 10000 ]; then echo "mem_clients_normal small"; else echo "mem_clients_normal leaked"; fi
rc shutdown nosave 2>/dev/null; pc shutdown nosave 2>/dev/null
wait
