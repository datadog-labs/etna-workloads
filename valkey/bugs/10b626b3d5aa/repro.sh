"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c incrbyfloat foo 0.024390243902439025
c incrbyfloat foo -0.024390243902439025
c get foo
c shutdown nosave
wait
