"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile m.log &
"$VALKEY_SERVER" --port $((PORT+1)) --save "" --appendonly no --dir . --logfile r.log --replicaof "127.0.0.1 $PORT" &
for p in $PORT $((PORT+1)); do
  until "$VALKEY_CLI" -p $p ping >/dev/null 2>&1; do sleep 0.1; done
done
until "$VALKEY_CLI" -p $((PORT+1)) info replication | grep -q master_link_status:up; do sleep 0.1; done
"$VALKEY_CLI" -p $PORT set test 1 EX 100
"$VALKEY_CLI" -p $PORT incrbyfloat test 0.1
"$VALKEY_CLI" -p $PORT wait 1 5000 >/dev/null
sleep 0.5
"$VALKEY_CLI" -p $((PORT+1)) get test
t=$("$VALKEY_CLI" -p $((PORT+1)) ttl test)
if [ "$t" -gt 0 ]; then echo "replica ttl ok"; else echo "replica ttl $t"; fi
"$VALKEY_CLI" -p $PORT shutdown nosave
"$VALKEY_CLI" -p $((PORT+1)) shutdown nosave
wait
