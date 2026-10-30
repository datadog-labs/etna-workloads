"$VALKEY_SERVER" --port $PORT --save "" --appendonly yes --appendfsync everysec --dir . --logfile s.log &
until "$VALKEY_CLI" -p $PORT ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p $PORT "$@"; }
c set k v >/dev/null
sleep 1.2
c config set rdb-key-save-delay 200000 >/dev/null
c bgrewriteaof >/dev/null
until c info persistence | grep -q aof_rewrite_in_progress:1; do sleep 0.01; done
printf 'incr foo\nwaitaof 1 0 2500\n' | "$VALKEY_CLI" -p $PORT
c shutdown nosave >/dev/null 2>&1
wait
