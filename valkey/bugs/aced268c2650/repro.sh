"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --rename-command set myset &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@" 2>&1; }
c command info myset | head -1
c acl setuser v on nopass -@all +myset
c acl setuser w on nopass '+@all' -set
c acl getuser w | sed -n 7,8p
c shutdown nosave
wait
