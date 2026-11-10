# Rationale

**Bug:** Transform streams did not wait for `_flush` to complete before emitting 'finish'. The flush was triggered from the 'prefinish' event, so 'finish' (and e.g. pipeline's callback) could fire while an async flush was still pending.

**Hunks** (in today's tree the Transform code lives in `lib/internal/streams/transform.js`):
1. `final(cb)` + `prefinish` guard + `Transform.prototype._final = final` (fix's `_stream_transform.js` hunks) are reverted to the old single `prefinish()` that calls `_flush` directly and never delays 'finish' (no `_final`, no callback).
2. `lib/zlib.js`: removed the `ZlibBase.prototype._final` override (fix's zlib hunk); it is unnecessary once Transform has no `_final`.

**Failing test:** `parallel/test-stream-pipeline` (the added flush-with-setTimeout case): the pipeline callback runs before `flushed` is true, so `assert.strictEqual(flushed, true)` fails.
