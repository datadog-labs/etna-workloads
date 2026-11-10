# Rationale

**Bug:** The http server socket only wrapped `on`/`addListener` (via a single `socketOnWrap`) to unconsume the parser when a `data`/`readable` listener was added. `socket.prependListener` was left unwrapped, so `req.socket.prependListener('data', ...)` never unconsumed the parser and the listener received no data.

**Change (lib/_http_server.js):**
- Hunk 1 (connectionListenerInternal): replaces the three `generateSocketListenerWrapper(...)` assignments with `socket.on = socketOnWrap; socket.addListener = socket.on;` — corresponds to the fix's first hunk; `prependListener` is no longer wrapped.
- Hunk 2 (bottom of file): replaces `generateSocketListenerWrapper` with the original `socketOnWrap`, which always calls `Socket.prototype.on` — corresponds to the fix's second hunk.

**Failing test:** parallel/test-http-server-unconsume:
`AssertionError: failed for socket.prependListener  '' !== 'hello world'`
Failed on both runs.
