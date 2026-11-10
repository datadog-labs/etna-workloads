# Rationale

**Bug:** Broadcast consumers receiving overlapping `next()` calls on the same iterator did not queue them. The second `next()` overwrote `state.resolve`/`state.reject`, so the first read was orphaned (never resolved) and the later call took the first chunk.

**Change (lib/internal/streams/iter/broadcast.js, one hunk):** removed the `if (state.resolve) { ...push into state.pending... return promise; }` block in the iterator's `next()`. This corresponds to the fix hunk that added that block. Without it, a second concurrent `next()` replaces the pending resolver as before the fix. The other fix hunks (pending queue draining, promote/reject/resolve helpers) remain but are inert because `state.pending` is never populated; I left them to keep the change minimal.

**Failing test:** `parallel/test-stream-iter-broadcast-basic` (`testOverlappingNextKeepsEarlierRead`) fails with an `AssertionError [ERR_ASSERTION]: Expected values to be strictly deep-equal` (the second read settles with the chunk instead of staying pending). It failed on both runs.
