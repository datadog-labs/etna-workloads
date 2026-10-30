"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" config resetstat
printf 'MULTI\r\nSET foo bar\r\nEXPIRE foo 0\r\nEXEC\r\n' | "$VALKEY_CLI" -p "$PORT" >/dev/null
"$VALKEY_CLI" -p "$PORT" info commandstats | grep -E '^cmdstat_(multi|exec|set|expire):' | cut -d, -f1 | sort
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
