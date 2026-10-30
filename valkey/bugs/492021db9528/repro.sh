#!/bin/bash
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log --enable-debug-command yes &
until "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; do sleep 0.1; done
c() { "$VALKEY_CLI" -p "$PORT" "$@"; }
c debug set-active-expire 0 >/dev/null
start=$(date +%s%N)
c blpop mylist 1 > out.txt &
bp=$!
sleep 0.3
# EXEC wakes the blocked client, but the key is expired by then; it blocks again
printf 'multi\nrpush mylist a\npexpire mylist 100\ndebug sleep 0.2\nexec\n' | c >/dev/null
wait $bp
ms=$(( ($(date +%s%N) - start) / 1000000 ))
echo "reply: [$(cat out.txt)]"
# original timeout is 1000ms from block time (~300ms before exec); reset would give ~1500+
if [ "$ms" -lt 1400 ]; then echo "timeout retained"; else echo "timeout reset"; fi
c shutdown nosave >/dev/null 2>&1
wait
