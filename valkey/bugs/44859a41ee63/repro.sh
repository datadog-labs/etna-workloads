"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
exec 3<>/dev/tcp/127.0.0.1/$PORT
printf 'HELLO 3\r\nCLIENT TRACKING on NOLOOP\r\nSET key1 1\r\nGET key1\r\nEVAL "return redis.call(\x27set\x27,\x27key1\x27,\x272\x27)" 1 key1\r\nPING\r\n' >&3
sleep 1
timeout 1 cat <&3 | tr -d '\r' | grep -a -E 'invalidate|PONG|^\+OK' 
exec 3>&-
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait
