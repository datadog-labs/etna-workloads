"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" msetnx x1 xxx x1 yyy
"$VALKEY_CLI" -p "$PORT" get x1
"$VALKEY_CLI" -p "$PORT" ping
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
sleep 0.5
grep -q "ASSERTION FAILED" s.log && echo ASSERTION
exit 0
