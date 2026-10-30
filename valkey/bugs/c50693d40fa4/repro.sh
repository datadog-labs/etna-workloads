"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c lpush testa 2 1 4 3 5
c sort testa by nosort store testb
c lrange testb 0 -1
c sort testa by nosort limit 0 3 store testb
c lrange testb 0 -1
c shutdown nosave
wait
