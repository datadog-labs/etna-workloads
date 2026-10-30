#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --enable-protected-configs yes --lua-enable-insecure-api yes &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@" 2>&1; }
c eval "return getfenv()" 0
c config set lua-enable-insecure-api no
c eval "return getfenv()" 0
c config set lua-enable-insecure-api yes
c eval "return getfenv()" 0
c shutdown nosave
wait
