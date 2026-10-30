"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c set foo bar
c zpopmin foo 0
c zpopmax foo -1
c zadd z 1 a 2 b 3 c
c zpopmin z -2
c zpopmax z 0
c zcard z
c shutdown nosave
wait
