# Re-introduced bug: http client 'drain' listener leak

**Bug.** The HTTP client registers `ondrain` on the socket (`socket.on('drain', ondrain)`) for each request. When the response completes and the socket is kept alive and reused by an agent, the listener was never removed. Each reuse added another `drain` listener, so listeners accumulated on pooled sockets (MaxListeners warnings, a slow leak).

**Change (lib/_http_client.js, 1 hunk).** In `socketOnData`, in the final `else if (parser.incoming?.complete && !statusIsInformational(...))` branch, I removed `socket.removeListener('drain', ondrain);`. This corresponds to fix hunk 1 (`@@ -506`). Without it, the drain listener stays on the socket after a complete response. A keep-alive socket then goes into the free pool with `drain` still attached.

**Fix hunk 2 (`responseKeepAlive`).** The release's `responseKeepAlive` has no `removeListener('drain', ondrain)` call. Cleanup now happens through `socketOnData`, so there was nothing to remove. Removing the `socketOnData` line is the faithful equivalent of the old behaviour.

**Failing test.** `parallel/test-http-agent-keepalive` fails on every run (run 3 times). The failure is at test line 155, in `checkListeners`: `assert.strictEqual(socket.listenerCount('drain'), 0)` throws `AssertionError: 1 !== 0`.
