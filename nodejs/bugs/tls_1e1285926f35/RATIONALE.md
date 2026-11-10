# Re-introduce: tls: honor pauseOnConnect option

**Bug:** `tls.Server` ignores `pauseOnConnect`; accepted TLS sockets are not paused (`socket.isPaused()` is false) even with `pauseOnConnect: true`.

The code moved to `lib/internal/tls/wrap.js`, and the `readable` flag no longer exists in the net.Socket call, so that part of the fix has no counterpart today.

Hunks (both in `lib/internal/tls/wrap.js`):
1. TLSSocket constructor: removed `pauseOnCreate: tlsOptions.pauseOnConnect` from the `net.Socket` call (fix hunk 1; the `readable` half no longer exists).
2. `tlsConnectionListener`: removed `pauseOnConnect: this.pauseOnConnect` from the options passed to the server-side TLSSocket (fix hunk 2).

**Failing test:** parallel/test-tls-server-parent-constructor-options — `AssertionError: Expected values to be strictly equal: false !== true` at line 49 (`socket.isPaused()` should be true with `pauseOnConnect: true`).
