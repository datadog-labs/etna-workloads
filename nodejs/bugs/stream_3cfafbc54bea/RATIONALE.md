# Re-introduced bug: pull() ignores abort while source next() is pending

Without the fix, `pull()` with an AbortSignal only checked the signal between batches. If the source's `next()` never resolved (waiting before yielding), aborting did not reject the consumer's pending `next()`; it hung.

## Change (lib/internal/streams/iter/pull.js, `createAsyncPipeline`)
Fix hunk: replaced the pre-fix loop with `yield* yieldAbortable(source, signal)` and `const normalized = yieldAbortable(source, signal)`. (In today's tree the race helper lives in `internal/streams/iter/utils` as `yieldAbortable`, so the fix's added helpers don't exist in pull.js.) I restored the old code: the fast path is `for await (const batch of source) { signal?.throwIfAborted(); yield batch; }` and `normalized = source`. Source reads are no longer raced against the signal, in both the no-transform and transform paths.

## Failing tests
`parallel/test-stream-iter-pull-async` fails (`not ok`, stable across 2 runs). The tests are `testPullSignalAbortWhileSourceNextPending` and `testPullSignalAbortWithTransformWhileSourceNextPending`: the pending `next()` never rejects with AbortError. I did not capture the exact failure message.
