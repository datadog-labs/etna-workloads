# Re-introduced bug: http.Agent response queue poisoning (CVE-2026-48931)

**Bug.** Idle keepAlive sockets in `agent.freeSockets` had no guard against unsolicited data. With the parser detached, a response the server wrote while the socket was idle sat in the socket and was consumed as the response to the next request that reused the socket (response-queue poisoning).

**Hunks.** In the release the fix's `socket.on('data', freeSocketDataGuard); socket.resume()` is expressed as `installFreeSocketDataGuard(socket)`, which hooks `handle.onread`. The matching removal in `reuseSocket` is `removeFreeSocketDataGuard(socket)`.
1. In the agent's `'free'` handler, I deleted the `installFreeSocketDataGuard(socket);` call. This corresponds to the fix's hunk adding `socket.on('data', ...)` and `socket.resume()`. Idle sockets are no longer guarded or destroyed when data arrives.
2. In `Agent.prototype.reuseSocket`, I deleted the `removeFreeSocketDataGuard(socket);` call. This corresponds to the fix's `removeListener('data', freeSocketDataGuard)` hunk. It is a no-op once no guard is installed.

The helper functions are left defined but unused. The release's later `hasPendingRead` hardening is not part of this fix, so I did not touch it.

**Failing test.** `parallel/test-http-agent-free-socket-data-guard` fails on both runs. The assertion on the free socket's `data` listener count or its `destroyed` state throws `AssertionError ... actual: false, expected: true, operator: 'strictEqual'`. `parallel/test-http-agent-keepalive` still passes on this release, because the release's guard uses `handle.onread` rather than a `'data'` listener.
