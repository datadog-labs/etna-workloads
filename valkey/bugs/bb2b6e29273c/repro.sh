"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --cluster-enabled yes &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
C="$VALKEY_CLI -p $PORT"
$C cluster addslotsrange 0 16383
until $C cluster info | grep -q cluster_state:ok; do sleep 0.1; done
$C eval "redis.call('set', 'foo', 'bar')" 1 bar
$C cluster countkeysinslot 12182
$C cluster countkeysinslot 5061
$C eval "return redis.call('cluster', 'slots')" 0 | head -3
$C eval "#!lua flags=no-cluster
return 1" 0
$C shutdown nosave
wait
