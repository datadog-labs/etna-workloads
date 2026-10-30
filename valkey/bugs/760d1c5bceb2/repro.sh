#!/bin/bash
declare -A PIDS
S="$VALKEY_SERVER"; C="$VALKEY_CLI"
P=$PORT; R=$((PORT+1)); N=$((PORT+2))
start() { "$S" --port $1 --save "" --appendonly no --dir . --logfile s$1.log --enable-debug-command yes >/dev/null 2>&1 &
  PIDS[$1]=$!; until "$C" -p $1 ping >/dev/null 2>&1; do sleep 0.1; done; }
waitfor() { for i in $(seq 300); do eval "$1" && return 0; sleep 0.1; done; return 1; }
mkdir -p d1 d2 d3
start $P; start $R; start $N
"$C" -p $P config set repl-diskless-sync yes >/dev/null
"$C" -p $P config set dual-channel-replication-enabled yes >/dev/null
"$C" -p $P debug pause-after-fork 1 >/dev/null
"$C" -p $P debug delay-rdb-client-free-seconds 60 >/dev/null
"$C" -p $R config set dual-channel-replication-enabled yes >/dev/null
"$C" -p $R replicaof 127.0.0.1 $P >/dev/null
waitfor 'grep -q "Done loading RDB" s$R.log' || echo "no load"
kill -STOP ${PIDS[$R]}
waitfor '[[ $(ps -o state= -p ${PIDS[$P]}) == T* ]]' || echo "primary not paused"
kill -CONT ${PIDS[$P]}
"$C" -p $P debug pause-after-fork 0 >/dev/null
waitfor '"$C" -p $P info replication | grep -q replicas_waiting_psync:1' || echo "no waiting psync"
"$C" -p $P replicaof 127.0.0.1 $N >/dev/null
waitfor 'grep -q "Done loading RDB" s$P.log || ! kill -0 ${PIDS[$P]} 2>/dev/null'
kill -0 ${PIDS[$P]} 2>/dev/null || echo "primary dead"
kill -CONT ${PIDS[$R]}
"$C" -p $N set foo bar
waitfor '! kill -0 ${PIDS[$P]} 2>/dev/null || [[ $("$C" -p $P get foo) == bar && $("$C" -p $R get foo) == bar ]]'
[[ $("$C" -p $P get foo) == bar && $("$C" -p $R get foo) == bar ]] && echo synced || echo "not synced"
sleep 1
grep -q "ASSERTION FAILED" s$P.log && echo ASSERTION
for p in $R $N $P; do "$C" -p $p shutdown nosave >/dev/null 2>&1; done
kill -CONT ${PIDS[$R]} 2>/dev/null
sleep 1
for p in "${PIDS[@]}"; do kill -9 $p 2>/dev/null; done
wait 2>/dev/null
