S="$VALKEY_SERVER"; C="$VALKEY_CLI"; P1=$PORT; P2=$((PORT+1))
"$S" --port $P1 --save "" --appendonly no --dir . --logfile m.log --enable-debug-command yes &
mkdir -p r; (cd r && "$S" --port $P2 --save "" --appendonly no --dir . --logfile r.log --enable-debug-command yes &) 
for p in $P1 $P2; do until "$C" -p $p ping >/dev/null 2>&1; do sleep 0.1; done; done
"$C" -p $P1 debug set-active-expire 0
"$C" -p $P2 debug set-active-expire 0
"$C" -p $P2 replicaof 127.0.0.1 $P1
until "$C" -p $P2 info replication | grep -q master_link_status:up; do sleep 0.1; done
"$C" -p $P1 sadd s foo
"$C" -p $P1 pexpire s 1
sleep 0.1
"$C" -p $P1 sadd s foo
"$C" -p $P1 wait 1 0
echo master: $("$C" -p $P1 type s)
echo replica: $("$C" -p $P2 type s)
"$C" -p $P2 shutdown nosave 2>/dev/null
"$C" -p $P1 shutdown nosave 2>/dev/null
wait
