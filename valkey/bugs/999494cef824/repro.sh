"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" <<'CMDS'
CLIENT TRACKING ON BCAST PREFIX FOOBAR PREFIX FOO
CLIENT TRACKING ON BCAST PREFIX FOO PREFIX BAR
CLIENT TRACKING ON BCAST PREFIX FO
CLIENT TRACKING ON BCAST PREFIX BARB
CLIENT TRACKING OFF
CMDS
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait
