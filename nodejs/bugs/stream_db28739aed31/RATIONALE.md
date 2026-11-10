# Re-introduced bug: pipeline swallows errors thrown by an async-function destination

**Bug.** When the last pipeline stage is an async function (or a thenable), completion was reported
from inside the promise `then` handler. A throw from the user's final callback was therefore caught by
the trailing `.catch()` and fed back into `finish`, so it was swallowed instead of reaching
`uncaughtException`.

**Changes (lib/internal/streams/pipeline.js only).**
1. The thenable handling is `PromiseResolve(then.call(ret, onFulfilled)).catch(onRejected)` instead of
   `then.call(ret, onFulfilled, onRejected)`. This corresponds to the fix's hunk replacing
   `.then(...).catch((err) => finish(err, null, true))` with `.then(ok, (err) => pt.destroy(err))`.
   `onFulfilled` also calls `finish()` synchronously rather than via `process.nextTick`, as the old
   `finish(null, val, true)` did. `onRejected` calls `finish(err)` directly, as the old catch did.
   I added `PromiseResolve` to the primordials import.
2. `finishImpl` calls `callback(error, value)` synchronously instead of `process.nextTick(callback, ...)`.
   In the old code the final callback ran synchronously inside `finish`, which is what put it inside the
   promise chain. Today's code defers it with nextTick, so without this the error would escape anyway.
   This corresponds to the fix's `finish(err, final)` / `callback(error, value)` hunk.

I did not re-create the old `wrap(ret, true, false, true)` argument order; the current code has no
equivalent.

**Failing tests** (both failed on two consecutive runs):
- `parallel/test-stream-pipeline-uncaught`: `AssertionError [ERR_ASSERTION]: Expected values to be strictly equal` (expected 'error').
- `parallel/test-stream-pipeline`: `Error [ERR_STREAM_DESTROYED]: Cannot call pipe after a stream was destroyed`.
  This one is probably collateral from the synchronous callback in change 2, not from the swallowed-error bug itself.
