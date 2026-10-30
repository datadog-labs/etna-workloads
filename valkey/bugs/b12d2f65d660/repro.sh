"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c xadd mystream 18446744073709551615-18446744073709551615 a b
c xadd mystream '*' c d
c xlen mystream
c shutdown nosave
wait
