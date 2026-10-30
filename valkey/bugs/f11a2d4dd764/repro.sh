"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" command getkeys eval "return 1" 0
"$VALKEY_CLI" -p "$PORT" command getkeys eval "return 1" 1 key
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
