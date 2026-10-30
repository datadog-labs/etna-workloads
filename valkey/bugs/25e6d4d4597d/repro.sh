#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly yes --appendfilename $' file seq \n\n.aof ' --enable-debug-command yes --dir . --logfile s.log &
for i in $(seq 100); do "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break; sleep 0.1; done
"$VALKEY_CLI" -p "$PORT" set k1 v1
"$VALKEY_CLI" -p "$PORT" bgrewriteaof >/dev/null
sleep 2
d1=$("$VALKEY_CLI" -p "$PORT" debug digest)
"$VALKEY_CLI" -p "$PORT" debug loadaof
d2=$("$VALKEY_CLI" -p "$PORT" debug digest)
[ "$d1" = "$d2" ] && echo digest-match || echo digest-mismatch
cat -A appendonlydir/*.manifest
"$VALKEY_CLI" -p "$PORT" shutdown nosave 2>/dev/null
wait
