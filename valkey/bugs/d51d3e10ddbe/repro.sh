"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --enable-debug-command yes &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c DEBUG SET-ACTIVE-EXPIRE 0
c HSETEX myhash EX 100 FIELDS 1 field1 value1
c INFO keyspace | grep -o 'keys_with_volatile_items=[0-9]*'
c SET myhash "string now"
c INFO keyspace | grep -o 'keys_with_volatile_items=[0-9]*'
c TYPE myhash
c shutdown nosave
wait
