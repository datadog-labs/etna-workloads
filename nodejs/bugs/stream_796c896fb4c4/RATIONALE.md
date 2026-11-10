# Re-introduced bug: Writer.end() ignores its AbortSignal

**Bug.** `end({ signal })` on push and broadcast writers validated the signal but never honored it: an already-aborted signal did not reject, and the writer was closed anyway. For push writers, an abort during buffered-data drain did not reject the pending end.

**Hunks** (the code has evolved since the fix; the writers already had `raceEndWithSignal` and state checks, so the bug is re-expressed):
- `lib/internal/streams/iter/push.js` `PushWriter.end()`: removed the `if (signal?.aborted) return PromiseReject(signal.reason)` check (fix hunk adding the pre-abort rejection), and return the pending-end promise directly rather than via `raceEndWithSignal(..., signal)` (fix hunk wrapping the pending end with the signal race). The signal is no longer used.
- `lib/internal/streams/iter/broadcast.js` `BroadcastWriter.end()`: removed the aborted check (fix hunk in broadcast.js) and return `endPromise` without `raceEndWithSignal`.

**Failing tests** (stable over 2 runs): parallel/test-stream-iter-push-writer, parallel/test-stream-iter-duplex, parallel/test-stream-iter-broadcast-basic all report `not ok` (the pre-aborted-signal `end()` does not reject and closes the writer). I did not capture the individual assertion messages.
