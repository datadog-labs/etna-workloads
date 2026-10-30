set +m
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log >/dev/null 2>&1 &
disown
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
exec 3<>/dev/tcp/127.0.0.1/$PORT
printf '*0\r\nPING\r\n' >&3
printf 'PING\r\n' >&3
timeout 2 head -c 14 <&3 2>/dev/null
exec 3>&-
"$VALKEY_CLI" -p "$PORT" ping
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
exit 0
