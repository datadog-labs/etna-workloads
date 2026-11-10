# Re-introduced bug: http socket.setEncoding allowed on server connections

## Bug
Before the fix, `socket.setEncoding()` on an HTTP server connection socket was not
blocked. Calling it before the parser consumed data changed the socket's stream
encoding, which led to a fatal error instead of a catchable, well-defined
`ERR_HTTP_SOCKET_ENCODING` error.

## Changes (reverse of the fix, re-expressed for today's code)
1. `lib/_http_server.js`: removed `socket.setEncoding = socketSetEncoding;` in
   `connectionListenerInternal` (fix hunk @@ -476). The socket again uses the default
   `Readable#setEncoding`.
2. `lib/_http_server.js`: removed the `socketSetEncoding()` function that throws
   (fix hunk @@ -493), and the now-unused `ERR_HTTP_SOCKET_ENCODING` import (fix hunk @@ -63).
3. `lib/internal/errors.js`: removed the `ERR_HTTP_SOCKET_ENCODING` definition
   (fix hunk in errors.js). It had no other users in lib/ or src/.

## Failing test
`parallel/test-http-socket-encoding-error` fails (`not ok`, stable across 2 runs):
`socket.setEncoding('')` no longer throws, so `assert.throws` fails with ERR_ASSERTION
(Missing expected exception; expected code `ERR_HTTP_SOCKET_ENCODING`,
message `Changing the socket encoding is not allowed per RFC7230 Section 3.`).
