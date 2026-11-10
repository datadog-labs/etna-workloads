# Bug
`OutgoingMessage.prototype.end(chunk, ...)` called after the message was already finished no longer reports `ERR_STREAM_WRITE_AFTER_END`. The chunk goes through the normal write/finish path, so `onFinish` can run again and the callback gets no error (null).

# Change (lib/_http_outgoing.js)
One hunk: removed the `if (this.finished) { onError(this, new ERR_STREAM_WRITE_AFTER_END(), ...); return this; }` guard inside `if (chunk)` in `end()`. This corresponds to the fix's only implementation hunk (the added guard before `write_`). In today's code the guard sits before the cork/`maybePrepareFinalChunk` logic, so it is removed there.

# Failing test
`parallel/test-http-outgoing-end-multiple` fails (stable over 2 runs):
`assert.strictEqual(err.code, 'ERR_STREAM_WRITE_AFTER_END')` -> `TypeError: Cannot read properties of null (reading 'code')`.
