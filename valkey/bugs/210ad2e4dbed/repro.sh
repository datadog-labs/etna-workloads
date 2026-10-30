"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
C="$VALKEY_CLI -p $PORT"
$C blpop empty_list 0x7FFFFFFFFFFFFFFF
$C blpop empty_list 9223372036854775807
$C shutdown nosave
wait
