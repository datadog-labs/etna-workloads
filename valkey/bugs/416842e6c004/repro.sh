#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
exec 3<>/dev/tcp/127.0.0.1/$PORT
printf 'CLIENT REPLY OFF\r\nSUBSCRIBE ch\r\n' >&3
sleep 0.3
"$VALKEY_CLI" -p "$PORT" publish ch hello
sleep 0.3
timeout 1 cat <&3 | tr -d '\r'
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
