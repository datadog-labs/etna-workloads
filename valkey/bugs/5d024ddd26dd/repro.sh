"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c HSETEX myhash EX 600 FIELDS 1 field1 val1
c HEXPIRE myhash 0 GT FIELDS 2 field1 field2
c HLEN myhash
c shutdown nosave
wait
