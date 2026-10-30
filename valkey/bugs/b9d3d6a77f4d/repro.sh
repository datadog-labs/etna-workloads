#!/bin/bash
echo "port $PORT" > v.conf
"$VALKEY_SERVER" v.conf --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c config set maxmemory 9223372036854775808
c config rewrite
grep -i '^maxmemory ' v.conf
c shutdown nosave
wait
