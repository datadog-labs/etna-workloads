"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
SP=$!
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
C() { "$VALKEY_CLI" -p "$PORT" "$@"; }
printf 'MULTI\nSET key value PX 3\nCLIENT PAUSE 10000 WRITE\nEXEC\n' | C >/dev/null
sleep 0.2
out=$(timeout 3 "$VALKEY_CLI" -p "$PORT" randomkey); rc=$?
if [ $rc -eq 124 ]; then echo "randomkey hung"; else echo "randomkey: $out"; fi

timeout 3 "$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
sleep 0.3
kill -9 $SP 2>/dev/null
wait $SP 2>/dev/null
exit 0
