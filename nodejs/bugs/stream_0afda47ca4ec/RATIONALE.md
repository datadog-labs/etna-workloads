# Re-introduced bug: stream share drains source under drop-newest

**Bug:** With `backpressure: 'drop-newest'`, when a consumer pulled while the buffer was full, the upstream result was discarded and the consumer immediately looped to pull again. One consumer's `next()` therefore drained the source (or looped indefinitely) while a slower consumer kept the buffer full.

**Changes (lib/internal/streams/iter/share.js):**
1. Removed the `if (!shouldBuffer) { await self.#waitForBufferSpaceAfterDrop(); }` call after `#pullFromSource(!shouldBuffer)` in `getNext`. This matches the fix's first hunk, so the consumer no longer waits for buffer space after a drop.
2. Removed the `#waitForBufferSpaceAfterDrop()` method. This matches the fix's second hunk and leaves no unused helper.

**Failing test:** `parallel/test-stream-iter-share-from` (`testShareDropNewest`) fails with `actual: 7, expected: 2` on `assert.strictEqual(pulls, 2)`. The source is fully drained. The failure was identical on both runs.
