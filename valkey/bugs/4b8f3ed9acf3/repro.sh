#!/bin/bash
printf '*3\r\n$3\r\nset\r\n$3\r\nfoo\r\n$5\r\nhello\r\n*3\r\n$3\r\nbla\r\n$3\r\nfoo\r\n$5\r\nhello\r\n' > appendonly.aof
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly yes --hide-user-data-from-log no --dir . --logfile s.log &
PID=$!
for i in $(seq 100); do sleep 0.1; kill -0 $PID 2>/dev/null || break; done
wait $PID
echo "server exit: $?"
grep -q "unknown command 'bla'" s.log && echo "LOG: unknown command 'bla'"
grep -q "Unknown command 'bla' reading" s.log && echo "LOG: old-style Unknown command"
exit 0
