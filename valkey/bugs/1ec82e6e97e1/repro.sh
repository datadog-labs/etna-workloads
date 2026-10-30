#!/bin/bash
# Reproducer for the SETRANGE integer-overflow bug in checkStringLength().
#
# tests/unit/type/string.tcl: "SETRANGE with huge offset" sends a SETRANGE
# with offset == LLONG_MAX and a 1-byte value. The fixed checkStringLength()
# widens offset+len to uint64_t before comparing against proto-max-bulk-len,
# so the overflow is caught and the command is rejected with a clean error.
# The buggy version computes "offset + sdslen(value)" as a plain (signed)
# long long at the call site; this overflows to a negative number, sails
# past the "size > proto_max_bulk_len" check, and is then used as an
# allocation size, crashing the server.

set -u

"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --enable-debug-command yes \
    --dir . --logfile s.log &
disown -a 2>/dev/null

for _ in $(seq 1 50); do
    "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break
    sleep 0.1
done

echo "SETRANGE_REPLY:"
"$VALKEY_CLI" -p "$PORT" setrange K 9223372036854775807 A

echo "PING_AFTER:"
"$VALKEY_CLI" -p "$PORT" ping

if grep -q "VALKEY BUG REPORT START" s.log; then
    echo "CRASHED"
fi

"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait >/dev/null 2>&1
exit 0
