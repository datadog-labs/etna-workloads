# Rationale

**Bug:** In `Server.prototype.listen` for pipe paths, when `listenInCluster` fails to create the handle (e.g. EADDRINUSE), `this._handle` is `null` and the error is emitted on the next tick. Without an early return, the code goes on to call `this._handle.fchmod(mode)` when `readableAll`/`writableAll` is set, throwing a TypeError on `null` instead of emitting the 'error' event.

**Hunk:** `lib/net.js`, pipe-path branch of `Server.prototype.listen`. It removes the `if (!this._handle) { return this; }` guard after `listenInCluster(...)`. This corresponds to the fix's single implementation hunk (which added that guard). The code has moved since the fix, but the guard is the same block.

**Failing test:** `parallel/test-net-server-listen-path` fails in both runs with `TypeError: Cannot read properties of null (reading 'fchmod')`.
