# Re-introduced bug: http2 streams don't complete gracefully after GOAWAY (nodejs/node#42713)

**Bug.** `Http2Stream#_destroy` called `session[kMaybeDestroy]()` synchronously, which can run
on the nghttp2 stack. When trailers are sent after the session was shut down (goaway), this
re-enters `Http2Session::SendPendingData`, so the trailer data is not flushed before the socket
is closed. The stream does not complete gracefully (the test hangs/times out).

**Hunks.**
1. `lib/internal/http2/core.js` (`Http2Stream#_destroy`): fix wrapped `session[kMaybeDestroy]()` in
   `setImmediate`; I removed the `setImmediate` wrapper and restored the synchronous call.
2. `lib/internal/js_stream_socket.js` (`doWrite`): fix added `else if (this._handle === null) return 0;`
   and removed `assert(handle !== null)`; I restored the old assert and removed the branch, so
   JSStreamSocket cannot accept writes after being closed.

**Failing test.** `parallel/test-http2-trailers-after-session-close` -> `not ok` (stable on 3 runs;
it fails by not completing / timing out, as when it lived in known_issues). The other two oracle
tests still pass in my runs.
