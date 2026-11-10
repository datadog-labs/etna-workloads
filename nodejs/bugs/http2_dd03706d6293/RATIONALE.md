# Re-introduced bug: unbound http2 socket proxy throws unhelpful errors

Bug: after an Http2Session is destroyed, `session[kSocket]` is undefined. The socket proxy
(`client.socket`) then dereferenced undefined, so `socket.example`, `socket.example = 1`
and `socket instanceof net.Socket` threw a generic TypeError instead of
`ERR_HTTP2_SOCKET_UNBOUND`.

Changes (all in lib/internal/http2/core.js, proxySocketHandler):
- `get` default branch: removed the `socket === undefined` check -> fix hunk 2 (get).
- `getPrototypeOf`: removed the check -> fix hunk for getPrototypeOf.
- `set` default branch: removed the check -> fix hunk for set.
- Removed the now-unused ERR_HTTP2_SOCKET_UNBOUND import (the error definition in errors.js is left, harmless).

Failing test: parallel/test-http2-unbound-socket-proxy (stable over 2 runs): ERR_ASSERTION,
expected `{ code: 'ERR_HTTP2_SOCKET_UNBOUND' }` but a TypeError without that code was thrown.
