"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@" 2>&1; }
c hsetex myhash KEEPTTL KEEPTTL KEEPTTL FIELDS
c hexpire myhash 10 NX NX FIELDS
c hgetex myhash PERSIST PERSIST FIELDS
c ping
c shutdown nosave >/dev/null 2>&1
wait
