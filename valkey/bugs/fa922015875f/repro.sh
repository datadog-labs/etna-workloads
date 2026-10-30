"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c hsetex k PX 100000 FIELDS 1 f v extra
c hsetex k PX 100000 FIELDS 2 f v
c exists k
c shutdown nosave
wait
