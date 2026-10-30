"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
C="$VALKEY_CLI -p $PORT"
$C rpush src a b c >/dev/null
$C blpop dst 2 > out.txt &
BG=$!
sleep 0.5
$C rename src dst
wait $BG
cat out.txt
$C shutdown nosave >/dev/null 2>&1
wait
