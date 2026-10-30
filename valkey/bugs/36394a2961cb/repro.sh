"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
exec 3<>/dev/tcp/127.0.0.1/$PORT
printf "*2\r\n\$6\r\nclient\r\n\$2\r\nid\r\n" >&3; read -t 1 -u 3 l
printf '*3\r\n$5\r\nBLPOP\r\n$6\r\nmylist\r\n$1\r\n0\r\n*3\r\n$3\r\nSET\r\n$3\r\n' >&3
sleep 0.5
printf 'key\r\n$5\r\nvalue\r\n' >&3
sleep 0.5
"$VALKEY_CLI" -p "$PORT" rpush mylist item
for i in 1 2 3 4 5 6 7 8; do read -t 1 -u 3 l || break; printf "%s\n" "${l%$'\r'}"; done
"$VALKEY_CLI" -p "$PORT" get key
"$VALKEY_CLI" -p "$PORT" shutdown nosave 2>/dev/null
wait
