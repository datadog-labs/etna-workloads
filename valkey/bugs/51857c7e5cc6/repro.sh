"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s1.log &
"$VALKEY_SERVER" --port "$((PORT+1))" --save "" --appendonly no --dir . --logfile s2.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
until "$VALKEY_CLI" -p "$((PORT+1))" ping >/dev/null 2>&1; do sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" hset h a 1 b 2
"$VALKEY_CLI" -p "$PORT" migrate 127.0.0.1 "$((PORT+1))" h 0 5000
"$VALKEY_CLI" -p "$((PORT+1))" hgetall h
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
"$VALKEY_CLI" -p "$((PORT+1))" shutdown nosave >/dev/null 2>&1
wait
