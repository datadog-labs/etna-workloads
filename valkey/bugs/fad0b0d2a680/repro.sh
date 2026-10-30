#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c config resetstat >/dev/null
exec 3<>/dev/tcp/127.0.0.1/$PORT
printf 'CLIENT ID\r\n' >&3
read -r -u 3 line; id=${line//[^0-9]/}
printf 'BLPOP list1 0\r\n' >&3
until [ "$(c info clients | grep -c '^blocked_clients:1')" = 1 ]; do sleep 0.1; done
c client unblock "$id" error
read -r -u 3 line; echo "reply: $line" | cut -c1-20
c info errorstats | grep UNBLOCKED | tr -d '\r'
c info commandstats | grep 'cmdstat_blpop' | sed 's/usec=[0-9.]*,usec_per_call=[0-9.]*,//' | tr -d '\r'
c info stats | grep total_error_replies | tr -d '\r'
c shutdown nosave 2>/dev/null
exec 3>&-
wait 2>/dev/null
