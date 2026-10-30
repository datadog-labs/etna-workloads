#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --cluster-enabled yes --cluster-config-file nodes.conf &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" cluster addslotsrange 0 16383 >/dev/null
until "$VALKEY_CLI" -p "$PORT" cluster info | grep -q cluster_state:ok; do sleep 0.1; done

# subscriber client: raw connection, ssubscribe to channel0, stay open
exec 5<>/dev/tcp/127.0.0.1/$PORT
printf 'CLIENT ID\r\nSSUBSCRIBE channel0\r\n' >&5
sleep 0.5
ID=$(timeout 1 head -c 200 <&5 | head -2 | tail -1 | tr -d ':\r')
[ -z "$ID" ] && ID=$("$VALKEY_CLI" -p "$PORT" client list | grep 'flags=' | grep -v 'cmd=client' | sed -n 's/.*\bid=\([0-9]*\).*/\1/p' | head -1)

printf 'MULTI\nSET k v\nCLIENT KILL ID %s\nEXEC\n' "$ID" | "$VALKEY_CLI" -p "$PORT" 2>&1
sleep 0.3
"$VALKEY_CLI" -p "$PORT" ping 2>&1
grep -q "ASSERTION FAILED" s.log && echo ASSERTION
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait
