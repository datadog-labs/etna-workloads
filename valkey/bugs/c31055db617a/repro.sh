"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --enable-debug-command yes &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" debug set-skip-checksum-validation 1
printf 'RESTORE _setbig 0 "\\x02\\x0A\\x02\\x5F\\x39\\xC0\\x06\\x02\\x5F\\x31\\xC0\\x00\\xC0\\x04\\x02\\x5F\\x35\\xC0\\x02\\xC0\\x08\\x02\\x5F\\x31\\x02\\x5F\\x33\\x09\\x00\\x7A\\x5A\\xFB\\x90\\x3A\\xE9\\x3C\\xBE"\nEXISTS _setbig\nSCARD _setbig\n' | "$VALKEY_CLI" -p "$PORT"
"$VALKEY_CLI" -p "$PORT" shutdown nosave
wait
