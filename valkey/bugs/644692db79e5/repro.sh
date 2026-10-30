"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --enable-debug-command yes &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
exec 3<>/dev/tcp/127.0.0.1/$PORT
printf '*3\r\n$6\r\nscript\r\n$5\r\ndebug\r\n$4\r\nsync\r\n' >&3
read -t 2 -r l <&3
printf '*3\r\n$4\r\neval\r\n$14\r\nreturn "hello"\r\n$1\r\n0\r\n' >&3
sleep 0.5
while read -t 0.5 -r l <&3; do :; done
printf '*2\r\n$6\r\nserver\r\n$4\r\nping\r\n' >&3
out=""
while read -t 1 -r l <&3; do out="$out$l"; done
case "$out" in *PONG*) echo "server ping: PONG";; *) echo "server ping: no PONG";; esac
exec 3>&-
"$VALKEY_CLI" -p "$PORT" ping
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
