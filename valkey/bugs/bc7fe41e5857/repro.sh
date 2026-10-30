"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
C="$VALKEY_CLI -p $PORT"
$C set foo 0
$C hincrbyfloat h f 1e308
$C hincrbyfloat h f 1e308
$C hset h2 f 1
$C hincrbyfloat h2 f inf
$C hincrbyfloat h2 f nan
$C hget h2 f
$C set k 1
$C incrbyfloat k 1e308
$C incrbyfloat k 1e308
$C shutdown nosave 2>/dev/null
wait
