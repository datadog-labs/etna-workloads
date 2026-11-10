# Re-introduced bug: IncomingMessage ignores the socket's readableHighWaterMark

**Bug:** `http.IncomingMessage` was constructed with default Readable options, so its
`readableHighWaterMark` did not follow the socket's (e.g. a custom `readableHighWaterMark`
passed to `net.createConnection`).

**Change (lib/_http_incoming.js):** The fix passed `{ highWaterMark: socket.readableHighWaterMark }`
to `Readable.call`. In today's code that is expressed as `Readable.call(this)` followed by a
`if (socket) { ... this._readableState.highWaterMark = hwm }` block. I removed that block, so
the message keeps the default HWM, which is the pre-fix behaviour.

**Failing test:** parallel/test-http-incoming-message-options fails with
`actual: 65536, expected: 1024` on `res.readableHighWaterMark`. I ran it twice and it failed both times.
