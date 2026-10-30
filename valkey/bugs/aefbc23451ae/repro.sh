"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c config set client-output-buffer-limit "normal 10mbs 10mb 60"
c config set client-output-buffer-limit "replica 10mb 10mbs 60"
c config set client-output-buffer-limit "pubsub 10mb 10mb 60s"
c config get client-output-buffer-limit
c shutdown nosave
wait
