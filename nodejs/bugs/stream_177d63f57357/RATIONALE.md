# Re-introduced bug: eos callback fires while writes are still pending

**Bug.** `finished()`/`eos()` on a stream with `readable: false` treated the stream as already finished when `writableFinished` was true or `isWritable()` was false, even if `_writableState.pendingcb > 0`. The callback therefore fired early, before outstanding write callbacks had completed (nodejs/node#46170).

**Hunk.** `lib/internal/streams/end-of-stream.js` — in the `!readable && (!willEmitClose || isReadable(stream)) && (writableFinished || isWritable(stream) === false)` branch, I removed the `(wState == null || wState.pendingcb === undefined || wState.pendingcb === 0)` condition. This corresponds to the fix's added `(wState == null || wState.pendingcb === 0)` line. In today's code the check also tolerates `pendingcb === undefined`, and the branch sets `immediateResult` instead of calling `process.nextTick(onclosed)`. Removing the condition restores the old behaviour.

**Failing test.** `parallel/test-stream-finished` fails ("not ok") on both runs. The last block, the Duplex with `readable: false` and a `setImmediate` write callback, now gets its callback before the write completes. That trips the assertion `isCalled === true` (and the `pendingcb === 0` check).
