"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --cluster-enabled yes --cluster-config-file n.conf &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
C="$VALKEY_CLI -p $PORT"
$C cluster addslots 0 >/dev/null
$C cluster slots >/dev/null
$C config set cluster-announce-port $((PORT+100))
$C cluster nodes | grep -o ":$((PORT+100))@" | sed 's/[0-9]*@/PORT@/'
$C config set cluster-announce-bus-port $((PORT+200))
$C cluster nodes | grep -c "@$((PORT+200)) "
$C cluster slots | grep -c "$((PORT+100))"
$C shutdown nosave
wait
