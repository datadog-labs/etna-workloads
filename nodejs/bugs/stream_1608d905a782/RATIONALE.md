# Bug
In the push stream queue (lib/internal/streams/iter/push.js), `consumerReturn()` and `consumerThrow()` did not settle reads already pending, so `iter.next()` promises hung forever after `iter.return()`/`iter.throw()`.

# Changes (push.js)
- `consumerReturn()`: removed `this.#resolvePendingReads()` (fix hunk: added `#resolvePendingReads()` in the return path, plus the `returned` branch in the read loop, which is still present in today's code but is no longer reached).
- `consumerThrow()`: removed `this.#rejectPendingReads(error)` (fix hunk: added `#rejectPendingReads(error)` on throw). The pendingEnd rejection from the fix now lives in `#terminateWriterFromConsumer` in this release, so I left it.

# Failing tests
parallel/test-stream-iter-push-writer fails (`not ok`, stable across 2 runs). The pending-read tests (`testConsumerReturnResolvesPendingRead`, `testConsumerThrowRejectsPendingRead`) hang because the read promise never settles. I did not capture the exact failure message.
