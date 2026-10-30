"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" function load foo bar '#!lua name=test
server.register_function("test", function() return "hello" end)' 2>&1
"$VALKEY_CLI" -p "$PORT" function list 2>&1
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait
