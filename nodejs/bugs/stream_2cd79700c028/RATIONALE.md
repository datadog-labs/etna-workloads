# Rationale

**Bug:** `Readable.from()` did not reject `null` values yielded by an iterable. The `null` was passed to `readable.push(null)`, which silently ended the stream instead of destroying it with `ERR_STREAM_NULL_VALUES`.

**Change (lib/internal/streams/from.js):** the release has four code paths (`nextSyncWithSyncValues`, `changeToAsyncValues`, `nextSyncWithAsyncValues`, `nextAsync`), where the fix touched the single `next()`. I removed the `=== null` checks (`reading = false; throw new ERR_STREAM_NULL_VALUES()`) in all four. Each corresponds to the fix's `if (res === null) { ... throw ... }` hunk, and the now-unused `ERR_STREAM_NULL_VALUES` import is removed, matching the fix's import hunk. Without the checks, a yielded `null` goes to `push()` and ends the stream, as before the fix.

**Failing test:** `parallel/test-stream-readable-next-no-null` reports "not ok". It expects an `'error'` event with `ERR_STREAM_NULL_VALUES` ('May not write null values to stream'), and none is emitted. `test-readable-from-iterator-closing` still passes. It was run twice, and the failure was the same both times.
