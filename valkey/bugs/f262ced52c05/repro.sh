#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log \
  --min-string-size-avoid-copy-reply 1 --min-string-size-avoid-copy-reply-threaded 1 &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
P=$(printf 'X%.0s' $(seq 128))
exec 3<>/dev/tcp/127.0.0.1/$PORT
printf 'HELLO 3\r\nSUBSCRIBE wiretest\r\n' >&3
sleep 0.3
printf 'PUBLISH wiretest %s\r\n' "$P" >&3
sleep 0.5
timeout 1 cat <&3 | tail -c +1 | tr -d '\r' | tail -n 8 | sed 's/^\(.\{20\}\).*/\1/'
exec 3>&-
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait
