S="$VALKEY_SERVER"; C="$VALKEY_CLI"
echo "user default on nopass ~* &* +@all" > users.acl
"$S" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --aclfile users.acl --enable-debug-command yes &
for i in $(seq 50); do "$C" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$C" -p "$PORT" ACL SETUSER tempuser on '>temppass' '~*' '&*' +@all
"$C" -p "$PORT" ACL SAVE
# client authenticates as tempuser and stays connected
( { echo "AUTH tempuser temppass"; echo "CLIENT ID"; sleep 3; } | "$C" -p "$PORT" > cid.out 2>&1 ) &
sleep 1
CID=$(tail -n1 cid.out)
"$C" -p "$PORT" DEBUG PROTECT-CLIENT "$CID"
grep -v tempuser users.acl > u2; cp u2 users.acl
"$C" -p "$PORT" ACL LOAD
"$C" -p "$PORT" CLIENT LIST | grep -c "id=$CID " 
"$C" -p "$PORT" CLIENT LIST | grep "id=$CID " | grep -o "user=[a-z]*"
"$C" -p "$PORT" ping
"$C" -p "$PORT" shutdown nosave 2>/dev/null
wait 2>/dev/null
