# Re-introduced bug: net.Server keepAlive / noDelay ignored (dbe5874c7e21)

**Bug.** In `onconnection` (lib/net.js), the server options `noDelay` and `keepAlive` were applied to the wrong handle: `handle` is the server's listening handle (`this`), not the accepted `clientHandle`. The keepAlive check used `self.setKeepAlive`, which does not exist on `net.Server`, so keepAlive was never enabled. The initial delay was read from the handle (`handle.keepAliveInitialDelay`, undefined) instead of from the server (`self.keepAliveInitialDelay`).

**Changes (single hunk in `onconnection`, mirroring the fix's one lib hunk, re-expressed for current code, which also sets `socket[kSetNoDelay]` etc.):**
- `self.noDelay && clientHandle.setNoDelay` / `clientHandle.setNoDelay(true)` -> `handle.setNoDelay` (the server handle). Reverses the fix's noDelay lines.
- `self.keepAlive && clientHandle.setKeepAlive` -> `self.keepAlive && self.setKeepAlive`, which is always falsy for a Server, so keepAlive is skipped. Reverses the fix's keepAlive condition.
- `clientHandle.setKeepAlive(true, self.keepAliveInitialDelay)` -> `handle.setKeepAlive(true, handle.keepAliveInitialDelay)`. Reverses the fix's call line.

**Failing tests** (stable across 2 runs): `parallel/test-net-server-keepalive` and `parallel/test-net-server-nodelay` both report "not ok". The `common.mustCall` wrappers on `clientHandle.setKeepAlive` and `clientHandle.setNoDelay` are never invoked. (I recorded only the TAP "not ok" status, not the exact message text.)
