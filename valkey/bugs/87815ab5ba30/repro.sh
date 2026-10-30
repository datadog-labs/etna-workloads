"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" command getkeys sort abc store def
"$VALKEY_CLI" -p "$PORT" command getkeys sort abc store invalid store stillbad store def
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
