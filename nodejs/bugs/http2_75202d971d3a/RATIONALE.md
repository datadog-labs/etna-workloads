# Bug
When an HTTP/2 client session is attached to an already-connected TLS socket (via `createConnection`) after a delay, data the socket already received (e.g. the server's SETTINGS frame) sits in the socket's readable buffer and is never fed to the Http2Session, so the session fails (Protocol error / hangs).

# Change
Single hunk in `lib/internal/http2/core.js` (Http2Session constructor): removed the `process.nextTick` block that drains `socket.read()` and calls `this[kHandle].receive(buf)`. This corresponds to the fix's `connect()` hunk in core.js (the loop that reinjects buffered data); in today's code that logic lives in the constructor. The native `Receive` method (src hunks) is left in place; it is simply unused, as before the fix's JS caller existed.

# Result
`parallel/test-http2-connect-tls-with-delay` fails (twice, stable): `Error [ERR_HTTP2_ERROR]: Protocol error at Http2Session.onSessionInternalError`.
