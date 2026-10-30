"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
exec 3<>/dev/tcp/127.0.0.1/$PORT
printf 'HELLO 3\r\n' >&3
sleep 0.5
dd bs=65536 count=1 <&3 >/dev/null 2>&1 &
wait $!
printf 'CLIENT TRACKING on\r\nGET a\r\nMSET a 1 b 2\r\nPING\r\n' >&3
sleep 0.5
timeout 1 cat <&3 | tr -d '\r'
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
