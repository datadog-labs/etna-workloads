#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --hide-user-data-from-log yes &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done

exec 3<>/dev/tcp/127.0.0.1/$PORT
printf 'psync replicationid -1\r\n' >&3
sleep 1
printf 'notacommand secretvalue\r\n' >&3
for i in $(seq 50); do grep -q "== CRITICAL == This primary is sending an error" s.log && break; sleep 0.1; done
exec 3>&-

"$VALKEY_CLI" -p "$PORT" ping
grep -q "sending an error to its replica: '\*redacted\*'" s.log && echo REDACTED
grep -q secretvalue s.log && echo LEAKED
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
