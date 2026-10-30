#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c evalsha NotValidShaSUM 0
c info errorstats | grep -i noscript | tr -d '\r'
c info commandstats | grep evalsha | sed 's/usec=[^,]*,usec_per_call=[^,]*,//' | tr -d '\r'
c info stats | grep total_error_replies | tr -d '\r'
c shutdown nosave
wait
