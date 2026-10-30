"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c sadd s a 1 2 3 4 5 6 7 >/dev/null
c srem s a >/dev/null
c object encoding s
c zadd z 1 1 2 2 >/dev/null
c zinter 2 s z
c zintercard 2 s z
c ping
sleep 0.3
grep -q "Unknown set encoding" s.log && echo PANIC
c shutdown nosave >/dev/null 2>&1
wait
exit 0
