#!/bin/bash
# Reproducer for: BLPOP + maxmemory-clients: successor eviction during
# ready-key reexec (handleClientsBlockedOnKey UAF, fixed upstream 2026-08-29).
#
# Two clients block on BLPOP for the same key. The first ("A") is the one
# that should be served; the second ("B") is made to have a large
# per-client output-buffer footprint (tot-mem) by leaving replies unread,
# so that when the key becomes ready and maxmemory-clients is lowered,
# client-eviction picks B as a victim and frees it *while* the ready-key
# list for that key is still being iterated to serve A. With the bug
# present, that free happens through a stale list iterator/node and can
# corrupt state or crash (ASan build); on the clean build it is handled
# safely and the server stays responsive.
set -u

: "${VALKEY_SERVER:?}" "${VALKEY_CLI:?}" "${PORT:?}"

LOG=s.log
"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . \
    --logfile "$LOG" --enable-debug-command yes &
SRV_PID=$!
# Detach from the job table so bash doesn't emit a "Segmentation fault
# (core dumped) <pid> ..." notice to stderr if/when the server crashes;
# that line would be non-deterministic (pid) and isn't needed, since a
# crash is instead detected via the log grep and connection failures below.
disown "$SRV_PID" 2>/dev/null

cli() { "$VALKEY_CLI" -p "$PORT" "$@"; }

for i in $(seq 1 100); do
    cli ping >/dev/null 2>&1 && break
    sleep 0.1
done

cli client no-evict on >/dev/null
cli config set maxmemory-clients 100mb >/dev/null
cli config set client-output-buffer-limit "normal 0 0 0" >/dev/null
cli config set min-io-threads-avoid-copy-reply 0 >/dev/null
cli config set min-string-size-avoid-copy-reply 0 >/dev/null
cli config set min-string-size-avoid-copy-reply-threaded 0 >/dev/null
cli setrange fat 300000 x >/dev/null

# Client A: served first, must survive. Use a plain TCP connection so the
# BLPOP request is sent without immediately reading the (blocked) reply.
exec 3<>"/dev/tcp/127.0.0.1/$PORT"
printf 'CLIENT NO-EVICT ON\r\nCLIENT SETNAME blpop_a\r\nBLPOP mylist 0\r\n' >&3

# Client B: inflate its server-side output buffer with unread GET replies,
# then block on the same key, so it becomes the eviction target.
exec 4<>"/dev/tcp/127.0.0.1/$PORT"
printf 'CLIENT SETNAME blpop_b\r\n' >&4
for i in $(seq 1 60); do
    printf 'GET fat\r\n' >&4
done
printf 'BLPOP mylist 0\r\n' >&4

# Wait until both clients are blocked and B's buffer is large enough.
for i in $(seq 1 100); do
    blocked=$(cli info clients | tr -d '\r' | sed -n 's/^blocked_clients://p')
    totmem=$(cli client list | tr ' ' '\n' | sed -n 's/^tot-mem=//p' | sort -rn | head -1)
    if [ "${blocked:-0}" = "2" ] && [ "${totmem:-0}" -ge 2000000 ]; then
        break
    fi
    sleep 0.1
done
echo "blocked_clients_before=${blocked:-0}"

# Lower maxmemory-clients to the server's minimum eviction limit and push
# the key, in one MULTI so the config change takes effect right before the
# key is signalled ready and the ready-key list for it gets served.
{
    echo "MULTI"
    echo "CONFIG SET maxmemory-clients 131072"
    echo "LPUSH mylist v1"
    echo "EXEC"
} | cli --no-raw > tx.out 2>&1
cat tx.out

echo "ping_after=$(cli ping 2>&1)"
echo "blpop_b_exists=$(cli client list | grep -c 'name=blpop_b')"

# Drain A's reply (printed by its connection); only report whether it
# looks like the expected BLPOP reply, not raw bytes/timings.
if read -t 5 -u 3 line1 && read -t 5 -u 3 line2 && read -t 5 -u 3 line3; then
    echo "a_reply=${line2}${line3}"
else
    echo "a_reply=TIMEOUT_OR_CLOSED"
fi
exec 3<&- 3>&-
exec 4<&- 4>&-

grep -q "ASSERTION FAILED" "$LOG" && echo ASSERTION
grep -qi "Segmentation Fault\|stack trace\|=== REDIS BUG REPORT" "$LOG" && echo CRASH_LOG

cli shutdown nosave >/dev/null 2>&1
wait "$SRV_PID" 2>/dev/null
exit 0
