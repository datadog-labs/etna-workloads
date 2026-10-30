"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c set key1 x
c sinter noset key1
c sinterstore dst noset key1
c sintercard 2 noset key1
c shutdown nosave
wait
