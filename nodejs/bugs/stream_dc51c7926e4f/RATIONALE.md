# Re-introduced bug
Broadcast writer `end()` signalled end-of-stream to the broadcast immediately, without waiting for
writes queued before `end()` (backpressured pending writes) to enter the shared buffer. Those
writes can then be dropped/stay pending, and `end()` never settles properly.

## Change (lib/internal/streams/iter/broadcast.js, `#finishEndIfReady`)
Corresponds to the fix's `#finishEndIfReady` / "drain pending writes before kEnd" logic (the
`#pendingWrites.length === 0` guard). Removing the guard makes `end()`/`endSync()` call
`kEnd` straight away, as the pre-fix code did, instead of only after pending writes drain.

## Failing test
parallel/test-stream-iter-broadcast-backpressure (testEndDrainsPendingWrite etc.):
"Mismatched noop function calls. Expected exactly 1, actual 0." (end promise never resolves).
Fails stably over repeated runs; basic test still passes.
