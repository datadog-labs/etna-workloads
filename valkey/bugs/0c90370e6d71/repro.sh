#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --enable-debug-command yes --sanitize-dump-payload yes &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" debug set-skip-checksum-validation 1
printf 'RESTORE key 0 "\\x0E\\x01\\x11\\x11\\x00\\x00\\x00\\x0A\\x00\\x00\\x00\\x01\\x00\\x00\\xF6\\xFF\\xB0\\x6C\\x9C\\xFF\\x09\\x00\\x9C\\x37\\x47\\x49\\x4D\\xDE\\x94\\xF5" replace\n' | "$VALKEY_CLI" -p "$PORT" 2>&1
"$VALKEY_CLI" -p "$PORT" exists key 2>&1
"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait
