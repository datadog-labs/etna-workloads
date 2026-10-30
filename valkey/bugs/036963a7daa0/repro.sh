# A script that outlives the busy-reply threshold re-enters the event loop; commands
# served meanwhile must not clobber server.current_client of the running script.
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
C() { "$VALKEY_CLI" -p "$PORT" "$@"; }
C config set busy-reply-threshold 10
C client setname main >/dev/null
exec 3<>/dev/tcp/127.0.0.1/$PORT
S='local n=0 for i=1,300000000 do n=n+i end for i=1,5 do redis.call("ping") end return n'
printf '*3\r\n$4\r\neval\r\n$%d\r\n%s\r\n$1\r\n0\r\n' ${#S} "$S" >&3
for i in $(seq 100); do C ping 2>&1 | grep -q BUSY && break; sleep 0.05; done
until [ "$(C ping 2>&1)" = PONG ]; do sleep 0.1; done
C client list | grep "cmd=eval" | grep -o "tot-cmds=[0-9]*"
C shutdown nosave >/dev/null 2>&1
wait
