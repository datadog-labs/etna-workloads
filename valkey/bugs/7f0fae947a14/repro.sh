#!/bin/bash
set -u

"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . \
    --logfile s.log --loglevel verbose --enable-debug-command yes \
    --use-exit-on-panic yes --crash-memcheck-enabled no &

for i in $(seq 100); do
    "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break
    sleep 0.1
done

# Corrupt stream payload with duplicate consumers (same bytes as the upstream
# test). Written to a file so the embedded NUL bytes survive, then fed to
# valkey-cli via -x so the RESTORE value arrives unmodified.
printf '\x0F\x00\x00\x00\x00\x01\x07\x6D\x79\x67\x72\x6F\x75\x70\x00\x00\x00\x02\x04\x6E\x61\x6D\x65\x2A\x4C\xAA\x9A\x7D\x01\x00\x00\x00\x04\x6E\x61\x6D\x65\x2B\x4C\xAA\x9A\x7D\x01\x00\x00\x00\x0A\x00\xCC\xED\x8C\xA7\x62\xEE\xC7\xC8' > payload.bin

"$VALKEY_CLI" -p "$PORT" -x restore key 0 < payload.bin
sleep 0.5
"$VALKEY_CLI" -p "$PORT" ping
grep -q "Duplicate stream consumer detected" s.log && echo DUPLICATE_LOGGED

"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait 2>/dev/null
