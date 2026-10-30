S="$VALKEY_SERVER"; C="$VALKEY_CLI"
P1=$((PORT+1))
mkdir m r1
(cd m; "$S" --port $PORT --save "" --appendonly yes --appendfsync always --logfile s.log &)
(cd r1; "$S" --port $P1 --save "" --appendonly no --logfile s.log &)
for p in $PORT $P1; do until "$C" -p $p ping >/dev/null 2>&1; do sleep 0.1; done; done
"$C" -p $P1 replicaof 127.0.0.1 $PORT >/dev/null
until "$C" -p $P1 info replication | grep -q master_link_status:up; do sleep 0.1; done
sleep 1
pid1=$("$C" -p $P1 info server | tr -d '\r' | awk -F: '/process_id/{print $2}')
kill -STOP $pid1
# client B writes first (older offset), client A writes later (newer offset)
{ echo "incr foo"; echo "waitaof 0 1 3000"; sleep 4; } | "$C" -p $PORT > wa.out &
sleep 0.5
{ echo "incr foo"; echo "wait 1 0"; sleep 4; } | "$C" -p $PORT > w.out &
sleep 1
kill -CONT $pid1
sleep 5
echo "wait:"; cat w.out
echo "waitaof (replica without AOF):"; cat wa.out
"$C" -p $PORT shutdown nosave 2>/dev/null
"$C" -p $P1 shutdown nosave 2>/dev/null
wait 2>/dev/null
