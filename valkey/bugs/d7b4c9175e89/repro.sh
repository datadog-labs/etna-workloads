"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c geoadd points -122.407107 37.794300 1
c geoadd points -122.227336 37.794300 2
c GEORADIUS points -122.407107 37.794300 30 mi ASC WITHDIST
c geodist points 1 1 km
c shutdown nosave
wait
