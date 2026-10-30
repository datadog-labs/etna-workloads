"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
keys=$(seq -f 'key%g' 1 260 | tr '\n' ' ')
"$VALKEY_CLI" -p "$PORT" command getkeys zunionstore target 260 $keys | head -3
"$VALKEY_CLI" -p "$PORT" command getkeys zunionstore target 2 a b
"$VALKEY_CLI" -p "$PORT" shutdown nosave 2>&1
wait
