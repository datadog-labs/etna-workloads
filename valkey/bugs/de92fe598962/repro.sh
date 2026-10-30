"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c acl setuser u1 on skip-sanitize-payload
c acl list
c acl getuser u1 | head -4
c acl setuser u2 resetchannels '&foo'
c acl list
c shutdown nosave
wait
