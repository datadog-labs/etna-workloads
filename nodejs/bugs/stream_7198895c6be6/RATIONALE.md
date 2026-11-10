# Rationale

**Bug:** overlapping `next()` calls on a single `share()` consumer were not serialized. Each call ran the pull loop independently, so concurrent calls could resolve out of order (the second `next()` could receive 'first').

**Change (lib/internal/streams/iter/share.js):**
1. Removed `pendingNext: PromiseResolve()` from the raw consumer state (fix hunk 1 added it).
2. The iterator's `next()` now calls `getNext()` directly rather than chaining it onto `state.pendingNext` with `PromisePrototypeThen` and re-storing the handled promise (fix hunk 2 introduced the chaining wrapper). The loop body (`getNext`) is unchanged and matches today's code, which has evolved since the fix.

**Failing test:** `parallel/test-stream-iter-share-async` (testShareConsumerConcurrentNextCalls) fails with `AssertionError: Expected values to be strictly equal: actual: 'second', expected: 'first'`. Failure is stable across repeated runs.
