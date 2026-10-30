#!/bin/bash
# Reproducer for: RESTORE's listpack validation fails to reject a quicklist
# listpack entry that starts exactly at the listpack's own EOF byte (fixed by
# upstream commit 1808618f5d1f, "Santize dump payload: fix invalid listpack
# entry start with EOF"). Without the fix the corrupt payload is accepted by
# RESTORE, and later access to the resulting list crashes the server.
set -u

"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . \
    --logfile s.log &
SRV_PID=$!
disown

# wait for the server to come up
for i in $(seq 1 50); do
    if "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1; then
        break
    fi
    sleep 0.1
done

# Crafted DUMP payload (a RDB_TYPE_LIST_QUICKLIST_2 value) whose single
# listpack node contains an entry that starts right at the listpack's EOF
# byte. It carries a valid RDB version/CRC64 footer, so it must be written
# to a file instead of being passed as a shell argument: argv strings can't
# contain the embedded NUL bytes the payload needs.
printf '\x12\x01\x02\x0b\x0b\x00\x00\x00\x01\x00\x81\x61\x02\xff\xff\x0a\x00\x7e\xd8\xde\x5b\x0d\xd7\x70\xb8' > payload.bin

# -x reads the last argument (the serialized value) from stdin, binary-safe.
"$VALKEY_CLI" -p "$PORT" -x restore corrupt 0 < payload.bin

# On the clean build RESTORE rejects the payload and no key is created. On
# the buggy build RESTORE accepts it, and reading the resulting (corrupt)
# list crashes the server.
"$VALKEY_CLI" -p "$PORT" type corrupt
"$VALKEY_CLI" -p "$PORT" lrange corrupt 0 -1

"$VALKEY_CLI" -p "$PORT" ping

grep -q "ASSERTION FAILED" s.log && echo ASSERTION

"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait "$SRV_PID" 2>/dev/null
