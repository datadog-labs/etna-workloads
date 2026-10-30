S="$VALKEY_SERVER"; C="$VALKEY_CLI"
P1=$((PORT+1)); P2=$((PORT+2))
"$S" --port $PORT --save "" --appendonly no --dir . --logfile m.log &
"$S" --port $P1 --save "" --appendonly no --dir . --logfile r1.log --replicaof "127.0.0.1 $PORT" &
R1=$!
"$S" --port $P2 --save "" --appendonly no --dir . --logfile r2.log --replicaof "127.0.0.1 $PORT" &
for p in $PORT $P1 $P2; do until "$C" -p $p ping >/dev/null 2>&1; do sleep 0.1; done; done
for i in $(seq 100); do
  [ "$("$C" -p $PORT info replication | grep -c 'state=online')" = 2 ] && break; sleep 0.1
done
kill -STOP $R1
"$C" -p $PORT set foo bar >/dev/null
for i in $(seq 100); do
  [ "$("$C" -p $P2 get foo)" = bar ] && break; sleep 0.1
done
r=$( (echo "set foo bar"; sleep 3; echo "eval \"return server.call('wait','2','0')\" 0") | "$C" -p $PORT | tail -1)
echo "WAIT in script: $r"
kill -CONT $R1
for p in $P1 $P2 $PORT; do "$C" -p $p shutdown nosave >/dev/null 2>&1; done
wait
