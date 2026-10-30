{ "$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log & } 2>/dev/null
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" ACL SETUSER rc on nopass +@all '&test'
( printf 'HELLO 3\r\nAUTH rc blank\r\nSUBSCRIBE test\r\nACL SETUSER rc resetchannels\r\nPING\r\n' | timeout 3 "$VALKEY_CLI" -p "$PORT" -3 >/dev/null 2>&1 ) 2>/dev/null
sleep 0.5
"$VALKEY_CLI" -p "$PORT" ping || echo DOWN
grep -q "ASSERTION FAILED\|crashed by signal" s.log && echo CRASH
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait 2>/dev/null
