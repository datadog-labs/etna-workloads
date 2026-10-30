"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c client kill id 0
c client kill id -1
c client list id 0
c client list id -1
c client list not-id 0
c client list not-id -1
c shutdown nosave
wait
