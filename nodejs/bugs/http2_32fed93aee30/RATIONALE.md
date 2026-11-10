# Rationale

**Bug:** `Http2ServerResponse.writeHead()` (compat API) crashed when the underlying stream had already been destroyed: it went on to call `stream.respond()`, which throws `ERR_HTTP2_INVALID_STREAM`, giving an uncaught exception (nodejs/node#24470). The fix added an early bail-out when the stream is destroyed.

**Change (lib/internal/http2/compat.js, `writeHead`):** The fix added `if (this.stream.destroyed) return false;`. In v26.13.0 the equivalent guard is the early return `if (state.closed || this.stream.destroyed || this.stream.closed) return this;`. I removed the two stream-based conditions (`this.stream.destroyed`, `this.stream.closed`), leaving `if (state.closed) return this;`, so a destroyed stream is no longer detected and writeHead proceeds to `[kBeginSend]` -> `stream.respond()`, which throws. `stream.closed` also had to go because it is true once the stream is destroyed and would still have caught the case.

**Failing test:** parallel/test-http2-compat-write-head-destroyed fails (stable over 2 runs) with an uncaught
`Error [ERR_HTTP2_INVALID_STREAM]: The stream has been destroyed` at `ServerHttp2Stream.respond` <- `[begin-send]` <- `Http2ServerResponse.writeHead`.
