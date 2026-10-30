printf 'save 100 100\n' > s.conf
"$VALKEY_SERVER" s.conf --port "$PORT" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" config get save
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
