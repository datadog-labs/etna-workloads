# Rationale

**Bug:** `toReadableSync()` in `lib/internal/streams/iter/classic.js` kept no state between `_read()` calls. When `push()` returned false in the middle of a multi-chunk batch, `read()` returned and the rest of that batch was lost. The next `read()` pulled a new batch from the iterator. With `highWaterMark: 1` and a single batch `[a, b, c]`, the stream yields only `a`.

**Hunks** (the fix has two implementation hunks, and both are reversed):
1. In `toReadableSync`, I removed the `hasBatch`/`batch`/`batchIndex` state and the "drain the saved batch first" block in `read()`. I restored the original loop, which does `const { value: batch, done } = iterator.next()` and then pushes `batch[i]` with a local index. This is the reverse of the fix's `read()` hunk. The old code lost the rest of the batch when it returned on backpressure.
2. In `destroy()`, I removed the `batch = undefined; hasBatch = false;` lines. This is the reverse of the fix's `destroy` hunk, and it is needed because those variables no longer exist.

The release's `try/catch` and `toClassicError` wrapping are unchanged.

**Failing test:** `parallel/test-stream-iter-to-readable` fails in `testBackpressureSyncMultiChunkBatch` with `actual: 'a', expected: 'abc'`. I ran it twice and it failed both times.
