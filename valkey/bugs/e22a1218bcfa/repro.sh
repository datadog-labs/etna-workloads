#!/bin/bash
S="$VALKEY_SERVER"; C="$VALKEY_CLI"
M=$PORT; R=$((PORT+1))
"$S" --port $M --save "" --appendonly no --dir . --logfile m.log &
mkdir -p rep && (cd rep && "$S" --port $R --save "" --appendonly no --dir . --logfile r.log &) 
for p in $M $R; do until "$C" -p $p ping >/dev/null 2>&1; do sleep 0.1; done; done
m() { "$C" -p $M "$@"; }
for j in $(seq 0 99); do m setrange key:$j 100000 asdf >/dev/null; done
m config set repl-timeout 1200 >/dev/null
m config set maxmemory-policy allkeys-random >/dev/null
m config set client-output-buffer-limit "replica 100000000 100000000 300" >/dev/null
m config set repl-backlog-size 10240 >/dev/null
m config set slowlog-log-slower-than -1 >/dev/null
m config set latency-tracking no >/dev/null
"$C" -p $R replicaof 127.0.0.1 $M >/dev/null
until "$C" -p $R info replication | grep -q master_link_status:up; do sleep 0.1; done
used=$(m info memory | tr -d '\r' | awk -F: '/^used_memory:/{print $2}')
nc=$(m info memory | tr -d '\r' | awk -F: '/^mem_not_counted_for_evict:/{print $2}')
m config set maxmemory $((used - nc + 300000)) >/dev/null
RPID=$("$C" -p $R info server | tr -d '\r' | awk -F: '/^process_id:/{print $2}')
kill -STOP $RPID
payload=$(head -c 1000 /dev/zero | tr '\0' A)
for k in $(seq 1 10000); do printf 'SETRANGE key:0 0 %s\r\n' "$payload"; done > cmds.txt
m --pipe < cmds.txt >/dev/null 2>&1
n=$(m dbsize); [ "$n" -ge 98 ] && echo "no eviction" || echo "evicted keys"
kill -CONT $RPID
"$C" -p $R shutdown nosave >/dev/null 2>&1
m shutdown nosave >/dev/null 2>&1
wait
