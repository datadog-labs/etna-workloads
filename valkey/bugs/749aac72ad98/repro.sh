"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c set foo foobar
c bitcount foo 0 4294967296
c bitcount foo 0 4294967299 bit
c bitcount foo 0 -1
c ping >/dev/null 2>&1 || echo DEAD
c shutdown nosave 2>/dev/null
wait
