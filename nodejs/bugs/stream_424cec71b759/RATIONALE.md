# Rationale

Bug: `merge()` in lib/internal/streams/iter/consumers.js requested the next value from a source as soon as the previous one settled, instead of waiting until the merged consumer resumed. Idle sources were drained ahead of the consumer, which pulled more data than was consumed.

Hunks (lib/internal/streams/iter/consumers.js):
1. `onSettled`: after queuing the value, immediately calls `iterator.next()` again (and re-adds it to `pendingPulls`). This corresponds to the fix's removal of the eager `.next()` from `onSettled`. Today's code uses `onRejected` and `pendingPulls`, so the pre-fix code is re-expressed with those.
2. Drain loop: the post-`yield` re-pull (`pendingPulls.add` plus `iterator.next()`) is removed, so only `yield item.value` remains. This corresponds to the fix's addition of the deferred `.next()` after `yield`.

Failing test: parallel/test-stream-iter-consumers-merge. It fails on both runs with `AssertionError: Missing expected rejection. actual: undefined, expected: { message: 'async cleanup on break' }`. The eager pull leaves a pending `.next()` on the source, so `return()` is treated as handled and its cleanup error is swallowed. The release's test file does not contain the fix's new `testMergeDoesNotDrainSourcesWhileIdle` test.
