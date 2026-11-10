# Re-introduced bug: TLS session/keylog listener added after destroy

**Bug:** Adding a `session` or `keylog` listener on a TLSSocket after it was destroyed (e.g. in a `close` handler) triggers the `newListener` hook, which calls `enableSessionCallbacks()`/`enableKeylogCallback()` without checking that the native handle still exists. Originally this segfaulted; the fix added a `this._handle` guard.

**Change** (lib/internal/tls/wrap.js, `keylogNewListener` and `newListener`; the code moved from lib/_tls_wrap.js and the listeners are now module-level functions using `this._handle`):
- Removed `if (!this._handle) return;` in `keylogNewListener`, matching the fix's first hunk (guard before `enableKeylogCallback`).
- Removed `if (!this._handle) return;` in `newListener`, matching the fix's second hunk.
Without the guards, the call is made on a destroyed socket, as before the fix. In today's code `_handle` is null, so this throws a TypeError instead of segfaulting, which is still a failure.

**Failing test:** parallel/test-tls-tlswrap-segfault-2 — `TypeError: Cannot read properties of null (reading 'enableSessionCallbacks')` at `newListener` (uncaught, exit code 1). It failed in both runs.
