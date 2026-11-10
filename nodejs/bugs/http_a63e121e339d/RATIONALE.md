# Re-introduced bug: http sets default Keep-Alive header even if user set one

**Bug:** `_storeHeader` always appended `Keep-Alive: timeout=N` (from server.keepAliveTimeout) when sending `Connection: keep-alive`, even if the user already set a `Keep-Alive` header, producing a duplicated/merged header (`timeout=50, timeout=12`).

**Change (lib/_http_outgoing.js, one hunk):** in `_storeHeader`, the condition `if (this._keepAliveTimeout && this._defaultKeepAlive)` became `if (this._keepAliveTimeout)`. This corresponds to the fix's hunk changing that same condition to add `&& this._defaultKeepAlive`; removing it restores the old behaviour. (The fix's `_defaultKeepAlive` initialisation and `matchHeader` `keep-alive` case hunks are left in place; they become inert without the check. The fix's `MathFloor` parenthesis correction is already present in today's code.)

**Failing test:** `parallel/test-http-keep-alive-timeout-custom` — `actual: 'timeout=50, timeout=12'`, `expected: 'timeout=50'`. Stable across two runs. `test-http-keep-alive-timeout` still passes.
