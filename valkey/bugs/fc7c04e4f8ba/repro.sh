"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
printf 'MULTI\r\nAUTH no-user foobar\r\nEXEC\r\n' | timeout 3 "$VALKEY_CLI" -p "$PORT"
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait
