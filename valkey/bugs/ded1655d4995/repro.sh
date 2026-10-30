"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c geoadd Sicily 12.75 36.995 test1 12.75 36.50 test2 13.00 36.50 test3
c geosearch Sicily fromlonlat 15 37 bybox 400 2 km
c geosearch Sicily fromlonlat 15 37 bybox 2 400 km
c shutdown nosave
wait
