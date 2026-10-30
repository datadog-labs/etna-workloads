S="$VALKEY_SERVER"; C="$VALKEY_CLI"
"$S" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --enable-debug-command yes --rdbcompression no &
for i in $(seq 100); do "$C" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$C" -p "$PORT" debug populate 100000 key 1000
"$C" -p "$PORT" save
"$C" -p "$PORT" shutdown nosave
sleep 0.5
"$S" --port "$PORT" --save "" --appendonly no --dir . --logfile s2.log --enable-debug-command yes --key-load-delay 50 --loading-process-events-interval-bytes 1024 &
for i in $(seq 100); do "$C" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$C" -p "$PORT" info persistence | grep -a '^loading:'
for j in 1 2 3 4 5 6 7 8; do "$C" -p "$PORT" debug log bla >/dev/null 2>&1; done
sleep 1
n=$("$C" -p "$PORT" info clients | grep -a '^connected_clients:' | tr -d '\r' | cut -d: -f2)
[ "$n" -lt 3 ] && echo "clients freed" || echo "clients leaked"
"$C" -p "$PORT" info persistence | grep -a '^loading:'
"$C" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait
