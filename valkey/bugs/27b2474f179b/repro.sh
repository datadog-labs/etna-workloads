"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@" 2>&1; }
c hset h a 1 b 2
c hexpire h 100 fields 1 a
c httl h fields 1 a
c hpexpire h 100000 fields 1 b
c hexpire h 100 fields 1 fields
c hgetex h ex 100 fields 1 a
c hsetex fields ex 100 fields 1 fields v
c httl fields fields 1 fields
c shutdown nosave
wait
