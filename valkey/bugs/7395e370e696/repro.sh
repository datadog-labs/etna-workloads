"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c XADD x 1-1 a 1
c XADD x 1-2 b 2
c XADD x 1-3 c 3
c XDEL x 1-2
c XDEL x 1-3
c XSETID x 1-2
c shutdown nosave
wait
