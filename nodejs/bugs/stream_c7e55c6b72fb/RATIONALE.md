# Re-introduced bug: writable.end() callback ordering relative to 'finish'

**Bug.** Before upstream fix c7e55c6b, the `end()` callback was run from a `'finish'` event listener, so it fired *after* the stream's `'finish'` listeners. The fix made it behave like `write()` callbacks relative to `_write`/`_final`: it is called inside `finish()` before `'finish'` is emitted. Re-introduced bug: the `end()` callback is called after `'finish'` listeners.

**Hunk.** `lib/internal/streams/writable.js`, `finish()`: `callFinishedCallbacks(state, null)` now runs after `stream.emit('finish')` instead of before. This reverses the fix hunk in `finish()` that added the kOnFinished callback loop before `emit('finish')` (the other fix hunks are already incorporated in a different form in this release, so the old error behavior cannot be reproduced without unrelated changes).

**Failing tests** (state-order assertions): parallel/test-stream-transform-final, parallel/test-stream-transform-final-sync, parallel/test-stream-writable-end-cb-error. These assert that the end callback runs before the 'finish' listener, so the assertions fail with the changed ordering.
