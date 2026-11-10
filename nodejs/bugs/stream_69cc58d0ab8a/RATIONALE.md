# Rationale

**Bug:** After `on('readable')` followed by `removeListener('readable')` and `resume()` in the same tick, the stream never flows and `'end'` is never emitted. The deferred `updateReadableListening` did not recognise that a `resume()` was already scheduled, so it ignored the pending resume.

**Change (lib/internal/streams/readable.js, `updateReadableListening`):** I removed the branch `if (hasPaused && !paused && resumeScheduled) { flowing = true }`. This corresponds to the fix hunk in `updateReadableListening` that added the `state.resumeScheduled && !state.paused` branch. The other fix hunks added a `paused` field and set it in `resume()` and `pause()`. Today's code already has that field, as the `kHasPaused` and `kPaused` bits. Those hunks are not reversed, because the old code simply never consulted the field. With the branch gone, the code behaves as it did before the fix. It only calls `resume()` when a data listener exists.

**Failing test:** `parallel/test-stream-readable-readable-then-resume` fails with `Mismatched noop function calls. Expected exactly 1, actual 0.` (the `'end'` handler is never called). It failed on every run.
