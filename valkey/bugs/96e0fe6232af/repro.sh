"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c select 10 >/dev/null
printf 'select 10\nset mykey original\neval "return redis.pcall(\\"select\\",\\"9\\")" 0\nget mykey\n' | "$VALKEY_CLI" -p "$PORT"
c shutdown nosave
wait
