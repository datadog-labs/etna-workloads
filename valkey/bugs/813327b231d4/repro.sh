"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --enable-debug-command yes &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c config set list-max-listpack-size -1
c config set list-compress-depth 12
c lpush lst $(printf '1 %.0s' $(seq 6000)) >/dev/null
c sort lst store dst
c object encoding dst
c debug object dst | grep -o "ql_listpack_max:[-0-9]* ql_compressed:[0-9]*"
c shutdown nosave
wait
