S="$VALKEY_SERVER"; C="$VALKEY_CLI"
"$S" --port "$PORT" --save "" --appendonly no --dir . --logfile m.log &
mkdir -p r && cd r
"$S" --port $((PORT+1)) --save "" --appendonly no --dir . --logfile r.log --replicaof "127.0.0.1 $PORT" &
cd ..
for i in $(seq 100); do "$C" -p "$PORT" ping >/dev/null 2>&1 && "$C" -p $((PORT+1)) ping >/dev/null 2>&1 && break; sleep 0.1; done
for i in $(seq 100); do "$C" -p "$PORT" info replication | grep -q state=online && break; sleep 0.1; done
"$C" -p "$PORT" config set min-replicas-to-write 1
"$C" -p "$PORT" config set lua-time-limit 10
"$C" -p "$PORT" eval "redis.call('set','x','script value')
while true do
  local info = redis.call('info','replication')
  if string.match(info, 'connected_slaves:0') then
    redis.call('set','x','after')
    break
  end
end
return 1" 1 x > out.txt 2>&1 &
EP=$!
for i in $(seq 100); do "$C" -p "$PORT" ping 2>&1 | grep -q BUSY && break; sleep 0.1; done
"$C" -p $((PORT+1)) replicaof no one
wait $EP
cat out.txt | sed 's/script: [0-9a-f]*/script: X/'
"$C" -p "$PORT" get x
"$C" -p $((PORT+1)) shutdown nosave
"$C" -p "$PORT" shutdown nosave
wait
