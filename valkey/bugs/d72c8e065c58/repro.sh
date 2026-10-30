"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" eval "return redis.error_reply('MY\r\nERR x')" 0
"$VALKEY_CLI" -p "$PORT" eval "error('a\r\nb')" 0
"$VALKEY_CLI" -p "$PORT" eval "return redis.error_reply('E1 x\r\n')" 0
"$VALKEY_CLI" -p "$PORT" ping
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
