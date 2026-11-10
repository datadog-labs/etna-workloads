# Re-introduced bug: readable stream with highWaterMark 0 doesn't flow to end

**Bug:** `maybeReadMore_` only loops while `state.length < state.highWaterMark`. With `highWaterMark: 0` the loop never runs, so a flowing stream whose `_read` pushes asynchronously stops calling `read()` and never reaches 'end' (nodejs/node#24915).

**Hunk (lib/internal/streams/readable.js, `maybeReadMore_`)** corresponds to the fix's single implementation hunk. I removed the extra or-condition `((state[kState] & kFlowing) !== 0 && state.length === 0)` from the while condition, so it is back to `state.length < state.highWaterMark` only. The code now uses `state[kState]` bit flags instead of `state.flowing`, but the logic is the same. The explanatory comment was left in place. The `const len` change from the fix was already present and is unchanged.

**Failing test:** `parallel/test-stream-readable-hwm-0-async` fails in repeated runs (the `_read` call count and the 'data'/'end' `mustCall` checks are not met because the flow stops). `test-stream-readable-hwm-0-no-flow-data` still passes.
