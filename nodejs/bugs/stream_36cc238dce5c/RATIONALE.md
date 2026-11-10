# Re-introduced bug: Broadcast.from pump not aborted on cancel (36cc238dce5c)

**NOT BUILT/VERIFIED**: the build step failed in my sandbox. The snapshot builder (`node_mksnapshot`) segfaults (rc=139). The crash also happens when I rebuild with the original, unmodified fixed source, and when I run the prebuilt `out/Release/node --build-snapshot`. It looks environmental, not caused by this edit. So the target test was not run against the change.

## Bug
`Broadcast.from(source)` runs a background pump that reads from `source`. Before the fix, `broadcast.cancel()` did not abort that pump. A pending `source.next()` stayed blocked and the pump kept running. If the source later produced a chunk, the pump wrote it into the cancelled broadcast. The source's `return()` was not called promptly. The pump's catch block also called `w.fail(error)` unconditionally.

## Change (lib/internal/streams/iter/broadcast.js), reversing the fix hunks
- Removed the `AbortController`/`abortSignal` import and the `yieldAbortable` import (fix hunks 1-2).
- Removed the `kOnCancel` symbol, its `this[kOnCancel] = null` initialisation, and the `onCancel?.(reason)` call in `[kCancel]` (fix hunks 3-5). Cancelling no longer notifies the pump.
- In `Broadcast.from`, removed the internal controller and `onCancel` registration. The pump again iterates `source` directly instead of `yieldAbortable(source, controller.signal)`. It checks only the user's `signal?.throwIfAborted()`. The catch block calls `w.fail(error)` unconditionally, and the `finally` that cleared `kOnCancel` is gone.

## Expected failure
`testBroadcastFromCancelWhileBlocked` in `parallel/test-stream-iter-broadcast-from` should fail. With the bug, `sourceReturned` stays false after cancel, and the late chunk reaches `writer.writevSync` (so `writesAfterCancel` is not 0). I did not run it, so I have no failure output to quote.
