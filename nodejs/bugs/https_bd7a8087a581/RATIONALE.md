# Bug
`https.Server` had no `close()` override, so it inherited `tls.Server.prototype.close`. Closing an HTTPS server therefore neither closed idle connections nor cleared the connections-checking interval (`kConnectionsCheckingInterval`). The interval stayed alive after `close()`.

# Change (lib/https.js only)
- Removed `Server.prototype.close` (hunk adding `close` calling `httpServerPreClose` + `tls.Server.prototype.close`). This restores the pre-fix behaviour where `https.Server` inherits the plain TLS close.
- Removed the now-unused `ReflectApply` and `httpServerPreClose` imports (corresponding to the fix's import hunks).
- `lib/_http_server.js` is unchanged: the `httpServerPreClose` helper and the `kConnectionsCheckingInterval` export are still there, and `http.Server` still uses them. They are harmless without the https caller.

# Failing tests (stable over 2 runs)
- parallel/test-https-server-close-destroy-timeout: `AssertionError: The expression evaluated to a falsy value` (`assert(server[kConnectionsCheckingInterval]._destroyed)`)
- parallel/test-https-server-close-idle: `AssertionError: The expression evaluated to a falsy value`, because idle connections aren't closed on `close()`.
