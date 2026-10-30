"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --enable-debug-command yes &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c config set tracking-table-max-keys 2
c debug pause-cron 1
exec 3<>/dev/tcp/127.0.0.1/$PORT
printf 'HELLO 3\r\nCLIENT TRACKING on\r\nmget 1{t} 2{t}\r\nmulti\r\n' >&3
sleep 0.5
c config set tracking-table-max-keys 1
printf 'ping\r\nexec\r\n' >&3
sleep 0.5
c ping
c debug pause-cron 0
c shutdown nosave 2>&1
sleep 0.3
grep -q "ASSERTION FAILED" s.log && echo ASSERTION
exit 0
