#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c config set busy-reply-threshold 10
( timeout 20 "$VALKEY_CLI" -p "$PORT" eval 'local f = function() while true do end end; while true do pcall(f) end' 0 >/dev/null 2>&1 & )
sleep 1
c script kill
sleep 1
for i in 1 2 3 4 5 6 7 8 9 10; do
  r=$(c ping 2>&1)
  [ "$r" = PONG ] && break
  sleep 0.5
done
echo "after kill: $r"
c shutdown nosave >/dev/null 2>&1
sleep 0.5
pkill -f "port $PORT" 2>/dev/null
wait
