# NOTES

`repro.sh` reproduces the UAF in `handleClientsBlockedOnKey()` (ready-key
reexec) that was fixed in the "Fix/ready key blocked client uaf" commit.

What it does:

1. Starts the server and configures it the same way the TCL test does:
   `maxmemory-clients 100mb`, zero client output-buffer limits, and the
   `*-avoid-copy-reply*` knobs disabled so unread replies stay charged to a
   client's `tot-mem`.
2. Opens two raw TCP connections (so requests can be sent without reading
   the replies) and blocks both on `BLPOP mylist 0`:
   - Client A (`blpop_a`): marked `CLIENT NO-EVICT ON`, should be served
     first and must not be the eviction victim.
   - Client B (`blpop_b`): first issues ~60 `GET fat` requests without
     reading any reply, inflating its server-side output buffer well past
     2MB, then blocks on the same key.
3. Waits until both clients are blocked and B's `tot-mem` is large.
4. In one `MULTI/EXEC`, lowers `maxmemory-clients` to 128KiB (the server's
   minimum eviction limit) and does `LPUSH mylist v1`. This makes the key
   ready and, when `handleClientsBlockedOnKey()` goes to serve A, client
   eviction runs and frees B — a different client on the same ready-key
   waiter list — in the middle of that iteration.
5. Checks that the server is still alive (`PING`), that A's `BLPOP` reply
   isn't corrupted, and that B is gone.

Difference between builds:

- **Clean build (fixed)**: `EXEC` returns normally, `PING` replies `PONG`,
  A gets its `BLPOP` reply, and B's connection is closed cleanly — i.e.
  `ping_after=PONG` and no `CRASH_LOG` line.
- **Buggy build (injection.patch applied)**: the server segfaults while
  iterating the ready-key list with a stale `listNode`, so the client
  connections are dropped (`Error: Server closed the connection`),
  `ping_after` becomes a connection-refused error, A never gets its reply
  (`a_reply=TIMEOUT_OR_CLOSED`), and the crash is detected via
  `grep`-for-marker on the server log (`CRASH_LOG`).

The background server job is `disown`ed right after starting it so bash
doesn't print a "Segmentation fault (pid) ..." job-control line to stderr
(which would include a non-deterministic pid); the crash is instead
detected deterministically via the log grep and the connection failures.
