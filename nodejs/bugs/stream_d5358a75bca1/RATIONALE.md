# Re-introduced bug: zero-byte broadcast writes not skipped

**Bug:** In the broadcast stream, `write('')` / `writev([])` append zero-byte entries to the buffer without increasing `bufferedBytes`, so they bypass backpressure and the buffer can grow without bound.

**Change (lib/internal/streams/iter/broadcast.js, `BroadcastImpl[kWrite]`):** removed the early `if (batchSize === 0) return true;` (and its comment). This corresponds to the fix's added hunk that skips empty batches. In today's code `batchSize` is `entry.byteLength` computed at the top, so only the skip was removed (the fix's second hunk, moving the `batchSize` computation, has no equivalent to undo).

**Failing test:** parallel/test-stream-iter-broadcast-backpressure — `testZeroByteWrites` fails with `AssertionError [ERR_ASSERTION]: Expected values to be strictly equal` (the zero-byte entries are delivered to the consumer, so the entry count is not 0). Failed in two consecutive runs.
