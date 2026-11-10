# Rationale

**Bug:** `util.callbackify()` returned a function whose `length` equalled the original's, ignoring the extra callback parameter (should be original length + 1).

**Change (lib/util.js, `callbackify`):** removed the block `if (typeof descriptors.length.value === 'number') descriptors.length.value++;` (and `length` from the adjacent comment). This corresponds to the fix's hunk adding the `descriptors.length.value++` guard (re-expressed for today's code, which also handles `name`). Without it the original's `length` descriptor is copied unchanged.

**Failing test:** `parallel/test-util-callbackify` — `AssertionError: actual: 0, expected: 1` (`cbAsyncFn.length`).
