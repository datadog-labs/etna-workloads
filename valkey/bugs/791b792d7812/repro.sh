#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
mem() { c info memory | tr -d '\r' | awk -F: '/^used_memory_vm_functions:/{print $2}'; }
for i in $(seq 1 2000); do
  c function load "#!lua name=lib$i
server.register_function('f$i', function() return 'hello' end)" >/dev/null
done
before=$(mem)
c function flush sync
after=$(mem)
if [ "$after" -lt "$before" ]; then echo "memory reclaimed"; else echo "memory NOT reclaimed"; fi
c shutdown nosave 2>/dev/null
wait
