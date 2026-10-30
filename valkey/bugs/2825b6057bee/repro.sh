"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c xgroup create x grp $ mkstream
for i in 1 2 3 4 5; do c xadd x $i-0 f v >/dev/null; done
c xreadgroup group grp Alice count 10 streams x '>' >/dev/null
c xdel x 1-0 2-0 3-0
c xautoclaim x grp Bob 0 0-0 count 2
c shutdown nosave
wait
