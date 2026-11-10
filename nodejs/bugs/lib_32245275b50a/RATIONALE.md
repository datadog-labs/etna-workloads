# Blob.stream() pull() never resolved on backpressure

**Bug:** In the byte stream returned by `Blob.stream()`, `readNext()` schedules a manual backpressure check. When `desiredSize` indicates no demand, it returned without resolving the pending `pull()` promise, so the ReadableStream's pull never finished and `pipeTo`/fetch of blob URLs hung (issues 48668, 48916, 48232).

**Change (lib/internal/blob.js, one hunk in the setImmediate backpressure check):**
The fix added `pending = this.pendingPulls.shift(); pending.resolve();` inside the `desiredSize <= 0` branch. Today's code has that block (plus `clearWakeupIfIdle()`) under `desiredSize < 0`. To restore the old behaviour I removed the shift/resolve/clearWakeupIfIdle block and changed the condition to `<= 0`, so the zero-demand case (highWaterMark 0) returns without resolving the pull, as before the fix. Changing only the condition did not fail the tests, and removing only the block did not either (today's `< 0` check lets desiredSize 0 keep reading), so both edits are needed.

**Failing test:** `parallel/test-blob` fails (`not ok 1 parallel/test-blob`) in two consecutive runs; the pipeTo / fetch cases never complete because pull() is never resolved.
