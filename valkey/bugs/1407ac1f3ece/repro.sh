S="$VALKEY_SERVER"; C="$VALKEY_CLI"
"$S" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$C" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
r() { "$C" -p "$PORT" "$@" 2>&1; }
r bitpos nokey 0 0 1 hello
r bitpos nokey 0 foo
r bitpos nokey 1 0 1 bit extra
r bitcount nokey 0
r bitcount nokey 0 1 bit x
r set s 1
r bitpos s 0 foo
r bitpos s 0 0 1 hello
r shutdown nosave
wait
