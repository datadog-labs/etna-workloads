# Re-introduced bug: fromSync() rejects sync iterables that also expose async/then protocols

**Bug.** `fromSync()` checked `isAsyncIterable(input)` and `typeof input.then === 'function'` before
checking for `Symbol.iterator`. An input with a sync iterator that also defined `Symbol.asyncIterator`
or `then()` was rejected with ERR_INVALID_ARG_TYPE instead of consuming the sync iterator.

**Change (lib/internal/streams/iter/from.js, fromSync).** The fix introduced `const isIterable = isSyncIterable(input)`
and gated the two rejection checks and the final check on it. Re-expressed for today's code (error messages differ):
1. Removed the `isIterable` const and the `!isIterable &&` guard on the async-iterable rejection, so any
   AsyncIterable is rejected, even if it is also sync iterable.
2. Removed the `!isIterable &&` guard on the thenable rejection, so any thenable object is rejected.
3. The final check went back to `!isSyncIterable(input)`.
Each hunk reverses the corresponding fix hunk.

**Failing test.** `parallel/test-stream-iter-from-sync` fails (`not ok`, stable across two runs) in the
dual-iterable / thenable-iterable cases of the fix, which now throw ERR_INVALID_ARG_TYPE
instead of returning 'sync'.
Message: `TypeError [ERR_INVALID_ARG_TYPE]: The "input" argument must be a synchronous input, not an async iterable.` thrown from testFromSyncPrefersIteratorForDualIterable.
