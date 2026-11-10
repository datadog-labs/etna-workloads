# Re-introduced bug: blob.stream() not a byte stream (BYOB reader unsupported)

**Bug:** `blob.stream()` created a default ReadableStream rather than a byte stream, so `getReader({ mode: 'byob' })` throws, and the desiredSize/backpressure semantics differ.

**Hunks (all in lib/internal/blob.js, `Blob.prototype.stream`):**
1. Removed `type: 'bytes'` from the `lazyReadableStream` options (fix hunk 1).
2. Removed `c.byobRequest?.respond(0)` after `c.close()` on EOS (fix hunk 2).
3. Removed the `buffer.byteLength !== 0` guard before `c.enqueue` (fix hunk 3, first part; only needed for byte streams).
4. Restored backpressure check `c.desiredSize <= 0` instead of `< 0` (fix hunk 3, second part; today's code uses setImmediate rather than queueMicrotask).

**Failing test:** `parallel/test-blob` -> `not ok`, AssertionError (strictEqual) on the BYOB / desiredSize assertions (BYOB reader unsupported on default stream; desiredSize values differ).
