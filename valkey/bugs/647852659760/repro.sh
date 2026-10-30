#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly yes --aof-use-rdb-preamble no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c set foo bar
c config set rdb-key-save-delay 1000000
c bgrewriteaof
for i in $(seq 100); do c info persistence | grep -q aof_rewrite_in_progress:1 && break; sleep 0.1; done
c config set aof-use-rdb-preamble yes
c config set rdb-key-save-delay 0
for i in $(seq 200); do c info persistence | grep -q aof_rewrite_in_progress:0 && break; sleep 0.1; done
sleep 1
cat appendonlydir/appendonly.aof.manifest
c shutdown nosave
wait
