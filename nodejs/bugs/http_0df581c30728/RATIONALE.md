# Re-introduced bug: http write() callback skipped for empty chunks

**Bug.** `OutgoingMessage.prototype.write()` returned early for empty strings/buffers, so the write callback was never invoked (nodejs/node#22066). Even when the early return was bypassed, `_writeRaw` swallowed empty data without handing it to the socket.

All changes are in `lib/_http_outgoing.js`:

1. `write_()`: re-added the early `if (chunk.length === 0) { return true; }` (placed after the `_hasBody` check, before corking). This is the fix's removed hunk in `write_`; the callback is dropped for empty chunks.
2. `write_()`: `if (msg.chunkedEncoding && chunk.length !== 0)` changed back to `if (msg.chunkedEncoding)`, matching the fix's third hunk. It is behaviourally redundant given hunk 1, as before the fix.
3. `_writeRaw()`: re-added the `else if (!data.length)` branch, which calls the callback on nextTick and returns `true` without writing to the socket. This is the fix's first hunk, using today's `defaultTriggerAsyncIdScope`/`async_id_symbol` imports.

**Failing tests** (stable across 2 runs):
- `parallel/test-http-outgoing-message-write-callback`: the callbacks for empty chunks are never called, so `results` does not deepEqual `expected`, and `res.end` callback assertions fail.
- `parallel/test-http-outgoing-message-inheritance`: the `Writable.write` `mustCall(…, 2)` expectation fails, because the empty write never reaches the socket.
- `test-http-server-response-standalone` passed in my runs (in one run it was flaky-ok); the two above fail.
