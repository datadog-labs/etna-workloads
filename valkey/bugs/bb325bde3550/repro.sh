#!/bin/bash
R="$PORT"; S=$((PORT+1))
"$VALKEY_SERVER" --port "$R" --save "" --appendonly no --dir . --logfile p.log &
mkdir -p r; (cd r && "$VALKEY_SERVER" --port "$S" --save "" --appendonly no --dir . --logfile r.log &) 
for p in $R $S; do until "$VALKEY_CLI" -p "$p" ping >/dev/null 2>&1; do sleep 0.1; done; done
"$VALKEY_CLI" -p "$S" replicaof 127.0.0.1 "$R"
until "$VALKEY_CLI" -p "$S" info replication | grep -q master_link_status:up; do sleep 0.1; done
"$VALKEY_CLI" -p "$R" config resetstat
"$VALKEY_CLI" -p "$R" set key value
until [ "$("$VALKEY_CLI" -p "$S" get key)" = value ]; do sleep 0.1; done
b=$("$VALKEY_CLI" -p "$R" info stats | tr -d '\r' | sed -n 's/^total_net_repl_output_bytes://p')
[ "$b" -gt 0 ] && echo "repl output bytes > 0" || echo "repl output bytes = $b"
"$VALKEY_CLI" -p "$S" shutdown nosave
"$VALKEY_CLI" -p "$R" shutdown nosave
wait
