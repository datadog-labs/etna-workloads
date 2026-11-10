# Re-introduced bug: net keepalive/noDelay (upstream 8e19dab677e6)

**Bug:** `socket.setKeepAlive()` ignores changes to the initial delay once keepalive is already enabled (only the `enable` flag is compared). Sockets created by a server with `noDelay`/`keepAlive` options also don't record that state in `kSetNoDelay`/`kSetKeepAlive`/`kSetKeepAliveInitialDelay`. So later `socket.setNoDelay(true)` calls the handle again, and `setKeepAlive(true, x)` is mishandled.

## Hunks (all in lib/net.js)
1. `Socket.prototype.setKeepAlive`: the fix's first hunk split the check into an early return plus a condition that also compares the delay. I restored the old single condition `this._handle.setKeepAlive && enable !== this[kSetKeepAlive]`. Today's code also compares interval and count, and I removed those too.
2. `onconnection`, noDelay: removed `socket[kSetNoDelay] = true;` (fix's second hunk).
3. `onconnection`, keepAlive: removed `socket[kSetKeepAlive] = true;` and `socket[kSetKeepAliveInitialDelay] = ...;`.

## Failing tests
- parallel/test-net-server-keepalive: fails. Delay changes are not forwarded to the handle, so the `mustCall(..., 2)` count is wrong.
- parallel/test-net-server-nodelay: fails. `socket.setNoDelay(true)` reaches the handle, which the test sets to `mustNotCall`.
Both failed in two consecutive runs.
