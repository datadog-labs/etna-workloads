# Re-introduced bug (upstream 937520a7, "stream: fix isDetachedBuffer validations")

**Bug:** the byte-stream code conflated "zero-length" with "detached" ArrayBuffers/views. A valid, non-detached zero-length view (e.g. `new Uint8Array(new ArrayBuffer(10), 0, 0)`) was reported as an `ERR_INVALID_STATE` "zero-length or detached" error instead of being handled by the proper checks.

Changes (both in lib/internal/webstreams/readablestream.js; today's code uses `ArrayBufferPrototypeGetDetached`, so the hunks are re-expressed):

1. `ReadableStreamBYOBRequest.respond()` — corresponds to the fix hunk replacing `viewByteLength === 0 || viewBufferByteLength === 0` with `isDetachedBuffer(viewBuffer)` + asserts. Restored the old zero-length-or-detached check.
2. `ReadableStreamBYOBRequest.respondWithNewView()` — corresponds to the fix hunk in the same area (detached check made precise, validation moved). Applied the same old conflated zero-length-or-detached check, so a non-detached zero-length view now throws ERR_INVALID_STATE instead of reaching the controller's closed-state ERR_INVALID_ARG_VALUE RangeError.

Not reproduced: the `enqueue` hunk, the `read()` message change and the validateBuffer move. They don't apply to current code or have no observable effect.

**Failing test:** parallel/test-whatwg-readablebytestream-bad-buffers-and-views (fails stably, 2 runs): the first block's `assert.throws(... ERR_INVALID_ARG_VALUE RangeError)` is no longer satisfied, so the exit check fails: `AssertionError: Expected values to be strictly equal: 1 !== 2` (pass count).
