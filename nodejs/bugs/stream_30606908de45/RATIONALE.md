# Re-introduced bug: merge() tags errors by truthiness

**Bug.** In `stream/iter` `merge()`, a rejected source `.next()` was queued as `{ error: err }` and the consumer checked `item?.error`. A falsy rejection reason (undefined, null, false, 0, '', NaN) was therefore not recognised as an error. The merge treated the item as a value and yielded `item.value` (undefined), and the rejection was silently swallowed.

**Changes (lib/internal/streams/iter/consumers.js).** The release has moved on since the fix. It now has `pendingPulls`, and cleanup no longer uses `skipAwaitCleanup`. The fix's `kind` tagging hunks are therefore the part that applies today. The other hunks are already in place or were replaced by `pendingPulls`.
1. `onRejected` pushes `{ error: reason }` instead of `{ kind: 'error', reason }`. This reverses the fix's `onRejected` hunk, which replaced `{ error: err }` with `kind: 'error'`.
2. The drain loop checks `if (item?.error) throw item.error;` instead of `item.kind === 'error'`. This reverses the fix's hunk that changed `item?.error` to `item.kind`.
3. The `kind: 'value'` field is removed from value items. This reverses the fix's hunk that added it.

**Failing test.** `parallel/test-stream-iter-consumers-merge` fails, with the failure in `testMergeFalsySourceErrors` (test file line 121). The same failure appeared in two runs.

I did not capture the assertion message. I only grepped the TAP output for the test name and the stack's first frame.

**Build note.** The first rebuild segfaulted in `node_mksnapshot` (inside `node_platform.cc`), and it did so even with my edit reverted. Deleting `node_platform.o` and rebuilding fixed it. I did not investigate the cause. My guess is a stale object left by the partial rebuild.
