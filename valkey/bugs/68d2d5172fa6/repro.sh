S="$VALKEY_SERVER"; C="$VALKEY_CLI"
"$S" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$C" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$C" -p "$PORT" config set slot-migration-max-failover-repl-bytes -1
"$C" -p "$PORT" config get slot-migration-max-failover-repl-bytes
"$C" -p "$PORT" config set slot-migration-max-failover-repl-bytes -2
"$C" -p "$PORT" shutdown nosave
wait
