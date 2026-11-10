# Rationale

**Bug:** After `on('readable')` followed by `removeListener('readable')`, the stream's flowing state stayed at `false` (set by the readable listener) instead of being reset to the initial null state. A later `on('data')` then did not start flowing, so data was never emitted. This is nodejs/node#24474.

**Hunk (lib/internal/streams/readable.js, `updateReadableListening`):** I removed the final branch, `else if ((state[kState] & kReadableListening) === 0) { state[kState] &= ~(kHasFlowing | kFlowing); }`. It corresponds to the fix's added `else if (!state.readableListening) { state.flowing = null; }`. Without it, flowing is never reset once the last 'readable' listener is removed and no 'data' listener exists.

The fix's other hunks (the kPaused symbol and the `isPaused` change) are already part of the release's bit-flag state. Only the reset branch needed removing to bring back the old behaviour.

**Failing test:** `parallel/test-stream-readable-data` fails because the `data` listener's `common.mustCall()` is never called. `parallel/test-stream-readable-pause-and-resume` still passes.
