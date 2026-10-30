"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c set foo bar
c expire foo 9223372036854775
c ttl foo
c set foo bar ex 9223372036854776
c get foo
c pexpire foo 9223372036854770000
c set k v
c expire k 9223372036854775807
c exists k
c shutdown nosave
wait
