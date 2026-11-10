# Re-introduced bug: http2 unknownProtocol socket never destroyed (CVE-2021-22883)

When an HTTP/2 server receives a TLS connection with an unknown ALPN protocol and no `unknownProtocol` listener, it writes a 403 and calls `socket.end()`. If the client never closes its side (e.g. `allowHalfOpen: true`), the socket stays open forever and leaks resources. The fix added an `unknownProtocolTimeout` option (default 10000 ms) and an unref'd timer that destroys the socket.

## Changes (lib/internal/http2/core.js)
1. In `connectionListener`'s unknown-protocol branch, removed the debug line, the `setTimeout` destroy timer, `timer.unref()`, and `socket.once('close', () => clearTimeout(timer))`. This reverts the fix's hunk in that branch, so the socket is only `end()`ed and may stay open indefinitely.
2. In `initializeOptions`, removed the `unknownProtocolTimeout` validation and default. This reverts the fix's `initializeOptions` hunk.
3. Reverted the `require('timers')` import to just `setImmediate`. This reverts the fix's import hunk. The `setTimeoutValue` rename is cosmetic, and the current code already has it.

## Failing test
`parallel/test-http2-server-unknown-protocol` fails ("not ok") on both runs. The server socket's `close` event never fires, so `common.mustCall` fails or the test times out.
