# Rationale

**Bug.** `writevSync()` did not validate chunk types before handing the batch to the push queue. Only strings were converted. Anything else was assumed to be a Uint8Array, so a call such as `writer.writevSync([1])` was not rejected with `ERR_INVALID_ARG_TYPE` up front. The invalid chunk went on to batch-entry creation instead.

**Hunk.** `convertChunks()` in `lib/internal/streams/iter/utils.js` corresponds to the fix's `allUint8Array` hunk. That helper no longer exists in this release, and `writevSync` and `writev` now share `convertChunks`. The fix changed the check from "no strings" to "every chunk is a Uint8Array". I put the old "strings only" check back. I removed the `WriterChunkSequence` conversion and `toUint8Array`'s type check from `convertChunks`. It now encodes strings and passes every other chunk through unchecked.

**Failing test.** `parallel/test-stream-iter-push-writer` fails (`not ok`) in two consecutive runs. The failing check is the new `testWritevSyncInvalidChunkDoesNotQueue`, at test line 220 (`assert.throws`). It expected `{ code: 'ERR_INVALID_ARG_TYPE' }`, but the thrown error had a different code (a plain TypeError from `snapshotByteView`, so `ERR_ASSERTION` was reported).

**Caveat.** I did not check whether the invalid chunk is left readable. The failure we see is the wrong error code.
