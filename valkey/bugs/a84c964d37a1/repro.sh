"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
for c in 'GET|' 'GET|SET' 'GET|SET|OTHER' 'CONFIG|GET GET_XX'; do
  "$VALKEY_CLI" -p "$PORT" $c 2>&1 | sed 's/ with args beginning with:.*//'
done
"$VALKEY_CLI" -p "$PORT" ping 2>&1
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait
