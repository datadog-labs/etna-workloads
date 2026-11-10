# Re-introduced bug: JS stream socket crash on simultaneous close/shutdown

Bug: if the wrapped stream is closed in the same tick as the upper layer closes the JSStreamSocket, doClose() has
already nulled `this._handle`, but a racing doShutdown() (or doWrite()) still proceeds to use it. doShutdown hits
`assert(handle !== null)` and throws an uncatchable ERR_INTERNAL_ASSERTION.

Changes (lib/internal/js_stream_socket.js only), each reverting a fix hunk:
- Removed the `kPendingClose` symbol and its initialisation in the constructor (hunks 1, 2).
- doShutdown: removed the `if (this[kPendingClose]) { return 0; }` early-out, so it uses `this._handle` (null) again.
- doWrite: removed the `kPendingClose` branch that stored the request for doClose to cancel (the later-added
  `this._handle === null` check was kept as it is separate code; only the pending-close branch belongs to the fix).
- doClose: removed setting `kPendingClose = true` and resetting it to false in the setImmediate.

Failing test: parallel/test-http2-client-connection-tunnelling ("not ok", ERR_INTERNAL_ASSERTION thrown from
doShutdown). Failed on two consecutive runs.
