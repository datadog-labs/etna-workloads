# Re-introduced bug: falsy cancellation reasons dropped

## Bug
`cancel(reason)` on broadcast and share (async and sync) treated the reason as an error only if it was truthy.
`cancel(0)`, `cancel('')`, `cancel(false)` and `cancel(null)` were therefore turned into clean completion (`done: true`) instead of rejecting or throwing with that reason.

## Why the plain reversal does not apply
The release no longer uses `#error = null` or `if (self.#error)`. It now uses sentinels (`kNoShareError`, `kNoBroadcastError`) plus a `hasReason` flag. The old defect is expressed as a truthiness test on the reason.

## Hunks
All three hunks change `const hasReason = arguments.length > 0;` to `const hasReason = !!reason;`. They correspond to the fix hunks that made the no-error sentinel `undefined`, so falsy reasons propagate instead of being treated as "no error".
- `lib/internal/streams/iter/broadcast.js`, `BroadcastImpl.cancel`: matches the fix's `#error` / `#error !== undefined` hunks in broadcast.js.
- `lib/internal/streams/iter/share.js`, `ShareImpl.cancel`: matches the `#sourceError` hunks in share.js.
- `lib/internal/streams/iter/share.js`, `SyncShareImpl.cancel`: matches the `SyncShareImpl` `#sourceError` hunks. I did not recreate the fix's reordering of the `#sourceError` check ahead of `state.detached` in the sync `next()`.

## Failing tests
After `make -j8`, these oracle tests report "not ok" in both runs:
- parallel/test-stream-iter-broadcast-basic
- parallel/test-stream-iter-share-async
- parallel/test-stream-iter-share-sync

I did not capture the failure message text, so I can't quote it. The failures come from the falsy-reason regression tests (`testCancelWithFalsyReason` and its share equivalents).
