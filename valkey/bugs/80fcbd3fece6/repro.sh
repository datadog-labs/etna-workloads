"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --cluster-enabled yes --cluster-config-file n.conf &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" cluster addslotsrange 0 16383
sleep 1
"$VALKEY_CLI" -p "$PORT" eval "return redis.call('cluster', 'slots')" 0 | head -3
"$VALKEY_CLI" -p "$PORT" eval "return redis.call('cluster', 'shards')" 0 | head -3
"$VALKEY_CLI" -p "$PORT" ping
grep -q "crashed\|ASSERTION\|Segmentation" s.log && echo CRASH
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait
