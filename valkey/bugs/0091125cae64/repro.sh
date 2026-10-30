"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
echo "lpos on missing key:"
"$VALKEY_CLI" -p "$PORT" lpos nokey a
"$VALKEY_CLI" -p "$PORT" ping
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait 2>/dev/null
exit 0
