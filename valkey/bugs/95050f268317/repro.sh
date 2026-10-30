#!/bin/bash
# Reproducer for: missing validation of a stream's RDB-loaded `length`
# against the actual number of non-tombstone entries. A payload can claim
# a positive length while every listpack entry is a deleted tombstone;
# this must be rejected at RESTORE/load time (upstream commit 95050f2683,
# "solve corrupt dump fuzzer crash in streams"). Without the check, the
# corrupt stream is accepted, and a later command that looks up the last
# valid ID (e.g. XSETID) hits streamLastValidID()'s
# serverPanic("Corrupt stream, length is %llu, but no max id") and crashes
# the server.
set -u

"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . \
    --logfile s.log --enable-debug-command yes --enable-protected-configs yes \
    --loglevel verbose --use-exit-on-panic yes --crash-memcheck-enabled no &
SRV_PID=$!

for i in $(seq 1 100); do
    "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break
    sleep 0.1
done

"$VALKEY_CLI" -p "$PORT" debug set-skip-checksum-validation 1 >/dev/null 2>&1

# A stream RDB payload (type 0x15 = RDB_TYPE_STREAM_LISTPACKS_3) whose
# listpack entries are all tombstones, but whose loaded length field is 1.
# Written to a file with printf (not a shell variable) so embedded NUL
# bytes survive; valkey-cli -x reads it as a single binary-safe argument.
printf '\x15\x01\x10\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x01\x28\x28\x00\x00\x00\x0F\x00\x00\x01\x02\x01\x01\x01\x81\x66\x02\x00\x01\x03\x01\x00\x01\x00\x01\x81\x76\x02\x04\x01\x03\x01\x01\x01\x01\x01\x81\x76\x02\x04\x01\xFF\x01\x02\x02\x01\x01\x00\x00\x02\x00\x50\x00\x3F\xD1\x7E\xA1\xC7\x54\x12\x57' > payload.bin

echo "=== RESTORE ==="
restore_out=$("$VALKEY_CLI" -p "$PORT" -x RESTORE _tomb_stream 0 < payload.bin 2>&1)
echo "$restore_out" | grep -qi "bad data format" && echo "RESTORE: rejected (Bad data format)" || echo "RESTORE: accepted ($restore_out)"

echo "=== XSETID ==="
xsetid_out=$("$VALKEY_CLI" -p "$PORT" XSETID _tomb_stream 1-1 2>&1)
echo "XSETID: $xsetid_out"

echo "=== PING ==="
ping_out=$("$VALKEY_CLI" -p "$PORT" ping 2>&1)
ping_rc=$?
if [ "$ping_rc" -eq 0 ] && [ "$ping_out" = "PONG" ]; then
    echo "PING: alive"
else
    echo "PING: server unreachable"
fi

if grep -qi "panic\|bug report" s.log; then
    echo "LOG: panic detected"
else
    echo "LOG: clean"
fi

"$VALKEY_CLI" -p "$PORT" shutdown nosave >/dev/null 2>&1
wait "$SRV_PID" 2>/dev/null
exit 0
