S="$VALKEY_SERVER"; C="$VALKEY_CLI"
"$S" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$C" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$C" -p "$PORT" "$@"; }
c xadd s 1-0 a 1 >/dev/null
c xgroup create s g 0 >/dev/null
# WATCH in one connection, modify via XGROUP CREATECONSUMER from another
(
  exec 3<>/dev/tcp/127.0.0.1/$PORT
  printf 'WATCH s\r\n' >&3; sleep 0.3
  "$C" -p "$PORT" xgroup createconsumer s g c1 >/dev/null
  printf 'MULTI\r\nPING\r\nEXEC\r\n' >&3; sleep 0.3
  timeout 0.5 cat <&3
)
c shutdown nosave
wait
