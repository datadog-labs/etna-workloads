"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c hset hash field value
c eval "redis.setresp(3); return redis.call('hgetall', KEYS[1])" 1 hash
c -3 eval "redis.setresp(3); return redis.call('hgetall', KEYS[1])" 1 hash
c eval "return redis.call('hgetall', KEYS[1])" 1 hash
c shutdown nosave
wait
