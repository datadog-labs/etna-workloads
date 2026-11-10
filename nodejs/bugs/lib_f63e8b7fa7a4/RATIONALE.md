# Re-introduced bug: http client socket path (fix f63e8b7fa7a4)

**Bug:** In `ClientRequest` with no agent, the options (including `path`, the HTTP request path, e.g. `/`) were passed straight to `createConnection` / `net.createConnection`. `net.connect` treats `path` as an IPC/unix socket path, so `http.get({path:'/', port, createConnection})` tried to connect to the unix socket `/` instead of TCP. `socketPath` was never mapped onto `path`, so a request with only `socketPath` plus a custom `createConnection` did not reach the socket.

**Change (lib/_http_client.js, one hunk, mirrors all three fix hunks):**
- Removed the `let opts = optsWithoutSignal; if (opts.path || opts.socketPath) {...}` block, which copied the options, set `path = socketPath` and cleared `path` otherwise.
- `createConnection` check and call, and `net.createConnection`/debug, use `optsWithoutSignal` again, as before the fix.

**Test:** `parallel/test-http-client-with-create-connection` reports `not ok`. In this sandbox it fails with `listen EPERM` on the unix socket (`common.PIPE`), because the sandbox forbids unix-socket listen. The test therefore also fails on a clean tree here and I could not confirm the failure comes from the bug. A TCP-only repro (`http.get({path:'/', port, createConnection: net.connect})`) fails with `ERR EPERM` on the changed tree, because it tries to connect to the unix socket `/`. On the fixed code it should succeed. Outside the sandbox the test should fail because of the bug.
