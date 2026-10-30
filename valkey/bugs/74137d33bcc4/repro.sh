"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
key=$(printf 'B%.0s' $(seq 1 100000))
c incr "$key" >/dev/null
u=$(c memory usage "$key")
if [ "$u" -ge 100000 ]; then echo "usage ok"; else echo "usage too small"; fi
c set k v >/dev/null
c memory usage k | awk '{print ($1>=17)?"small ok":"small too small"}'
c shutdown nosave
wait
