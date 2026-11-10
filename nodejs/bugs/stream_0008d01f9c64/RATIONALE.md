# Rationale

**Bug:** `share()` and `broadcast()` with an `options.signal` cancelled the multi-consumer on abort without passing `signal.reason`, so consumers saw clean completion (`done: true`) instead of an AbortError / the abort reason.

**Hunks (the code was refactored since the fix: both factories now call `[kSetFactorySignal]` on the impl):**
- `lib/internal/streams/iter/share.js` `[kSetFactorySignal]`: `this.cancel(signal.reason)` -> `this.cancel()`. Corresponds to the fix's `onShareCancel` hunk (`shareImpl.cancel(signal.reason)` vs old `shareImpl.cancel()`).
- `lib/internal/streams/iter/broadcast.js` `[kSetFactorySignal]`: same change. Corresponds to the `onBroadcastCancel` hunk.
- The fix's third hunk (detached consumers rethrow stored error) is already covered in today's code by `state.error` handling; I didn't touch it, since the reason is no longer propagated anyway.

**Failing tests:** `parallel/test-stream-iter-broadcast-from` and `parallel/test-stream-iter-share-async` both "not ok" (consumers complete cleanly instead of rejecting with AbortError / the reason). Stable over two runs.
