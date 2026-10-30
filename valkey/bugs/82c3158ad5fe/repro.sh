S="$VALKEY_SERVER"; C="$VALKEY_CLI"
"$S" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$C" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$C" -p "$PORT" "$@"; }
c config set notify-keyspace-events KEA >/dev/null
c xgroup create s g '$' mkstream
( timeout 2 "$C" -p "$PORT" psubscribe '__keyevent@0__:xgroup-createconsumer' > sub.out 2>&1 & )
sleep 0.5
c config resetstat >/dev/null
c xreadgroup group g alice streams s '>'
c xgroup createconsumer s g bob
sleep 2
c info persistence | grep rdb_changes_since_last_save
c xinfo consumers s g | grep name
grep -c . sub.out
grep -A0 '^__keyevent' sub.out | wc -l
c shutdown nosave
wait
