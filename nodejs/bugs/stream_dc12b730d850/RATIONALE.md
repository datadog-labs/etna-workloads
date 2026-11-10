# Re-introduced bug (dc12b730d850)

**Bug:** After `writer.writeSync(...)` then `endSync()` returns -1 (the queue is in the `closing` state with buffered data), a follow-up `writer.end()` resolves immediately with the byte count. It should stay pending until the reader drains the queued data.

**Change (lib/internal/streams/iter/push.js, `PushQueue.end()`):** The fix split the `closing`/`closed` check so that `closing` returns -3, which makes `PushWriter.end()` wait for the drain. I merged the two cases back into `if (closing || closed) return this.#bytesWritten;`, as before the fix. The fix's `PushWriter.end()` hunk, which reuses an existing pending-end promise, is not reverted. It is now unreachable, because nothing returns -3 in the `closing` state. The fix's duplex.js hunks are not reverted. The current `closeDuplexChannel` already differs from the pre-fix code, and the push.js change alone brings the bug back.

**Failing test:** `parallel/test-stream-iter-push-writer` fails (`not ok`) in `testEndAfterEndSyncWaitsForDrain`. The assertion `ended === false` fails with `actual: true, expected: false`. It failed on both runs.
