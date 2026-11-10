# Re-introduced bug: http2 secure server with allowHTTP1 doesn't close idle connections

**Bug.** `Http2SecureServer#close()` with `allowHTTP1: true` does not close idle HTTP/1 keep-alive connections, so `server.close()` hangs until the clients disconnect (nodejs/node#51493).

**Changes (lib/internal/http2/core.js).** The release has moved on, so these are re-expressed for today's code.
1. In `close()`, remove the `httpServerPreClose(this)` call when `allowHTTP1 === true`. This matches the fix's new `close()` method. Without it, idle connections are never closed.
2. Remove the `closeIdleConnections()` override that delegates to `HttpServer.prototype.closeIdleConnections`. This matches the fix's added `closeIdleConnections` method.
3. Remove the `this.on('listening', setupConnectionsTracking)` line in the constructor. This matches the fix's added hook. Without connection tracking nothing can be closed.
4. Remove the now-unused imports `HttpServer`, `httpServerPreClose` and `setupConnectionsTracking`. This matches the fix's `require('_http_server')` hunk.

**Failing test.** `parallel/test-http2-allow-http1` fails on both runs with `AssertionError [ERR_ASSERTION]: server should been closed immediately`.
