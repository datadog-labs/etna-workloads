"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
for c in SET BITFIELD GET MSET; do
  echo "$c: $("$VALKEY_CLI" -p "$PORT" command info $c | sed -n 3p)"
  "$VALKEY_CLI" -p "$PORT" command info $c | grep -c movablekeys
done
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
