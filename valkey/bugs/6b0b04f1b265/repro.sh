#!/bin/bash
set -u

"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --enable-debug-command yes \
    --dir . --logfile s.log &
disown

for i in $(seq 1 100); do
    "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break
    sleep 0.1
done

"$VALKEY_CLI" -p "$PORT" eval '
local a = {}
for i=1,7999 do
    a[i] = 1
end
return redis.call("lpush", "l", unpack(a))
' 0

"$VALKEY_CLI" -p "$PORT" ping

if grep -q "Guru Meditation" s.log 2>/dev/null; then
    echo CRASHED
fi

"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait 2>/dev/null
