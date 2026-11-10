# Rationale
Bug: `tls.connect()` ignored `keepAlive`, `keepAliveInitialDelay` and `noDelay`; they were never passed to the `net.Socket` constructor, so `afterConnect()` never applied them.

Changes (lib/internal/tls/wrap.js only; the symbol move in lib/internal/net.js and lib/net.js is a refactor already present and needed no reversal):
- In `TLSSocket()`, removed `noDelay`/`keepAlive`/`keepAliveInitialDelay` from the options passed to `net.Socket` (fix hunk 2).
- In `exports.connect()`, removed the same three options from the `tlssock` constructor options (fix hunk 3).

Failing test: parallel/test-tls-connect-keepalive-nodelay (stable across 2 runs):
`AssertionError: Expected values to be strictly equal: actual: false, expected: true` (socket[kSetKeepAlive]).
