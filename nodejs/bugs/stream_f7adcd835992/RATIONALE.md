# Rationale

**Bug:** `broadcast.push()` and `share.pull()` only delegated to `pullWithConsumerCleanup()` when transforms were given. With only `{ signal }`, the raw consumer was returned directly. The signal was never wired up, so a pending `next()` did not reject when the signal aborted (it hung).

**Hunks** (the release code differs from the fix's context, but the condition is the same):
1. `lib/internal/streams/iter/broadcast.js`, `BroadcastImpl.push`: `if (transforms.length > 0 || signal)` became `if (transforms.length > 0)`. This reverses the fix's broadcast.js hunk. Signal-only consumers now skip `pullWithConsumerCleanup`.
2. `lib/internal/streams/iter/share.js`, `ShareImpl.pull`: the same change. This reverses the fix's share.js hunk.

**Failing tests** (stable across two runs):
- `parallel/test-stream-iter-broadcast-basic`: fails with `Mismatched noop function calls. Expected exactly 1, actual 0.` The new `testPushAbortSignalRejectsPendingNext` pending `next()` never rejects.
- `parallel/test-stream-iter-share-async`: also reports `not ok`. This is `testSharePullAbortSignalRejectsPendingNext`, and I did not capture its message.
