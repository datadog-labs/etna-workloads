# Re-introduced bug: _read() stops being called / 'readable' stops firing (cd302d70)

**Bug.** A `Readable` that pushes data synchronously from `_read()` and is consumed via `'readable'` + `read()` stops being driven after a few cycles. The `emittedReadable` flag stays set, so `emitReadable()` never schedules another `'readable'` event. `_read()` is therefore no longer called indefinitely.

**Changes (both in `lib/internal/streams/readable.js`).**
1. `emitReadable_()`: removed `state[kState] &= ~kEmittedReadable;` after `stream.emit('readable')`. This corresponds to the fix's `state.emittedReadable = false;` hunk. The `debug(...)` hunks in the fix are logging only and were not reverted.
2. `Readable.prototype.read()`: for `n !== 0`, it now clears only `kEofReadablePending` and no longer clears `kEmittedReadable`. The fix has no hunk for this. Today's `read()` resets the flag itself, which made the fix's hunk redundant, so removing hunk 1 alone gave no failure. Hunk 2 is therefore needed to bring back the old behaviour, where only `emitReadable_` reset the flag.

**Result.** `parallel/test-stream-readable-infinite-read` fails on both runs. The message is `Mismatched <anonymous> function calls. Expected exactly 12, actual 3.` for `read`, and `Expected exactly 11, actual 1.` for the `'readable'` handler.
