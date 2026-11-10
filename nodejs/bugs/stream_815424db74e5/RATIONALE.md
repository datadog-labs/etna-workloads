# Bug: pre-aborted signal leaks a consumer in Broadcast.push() / Share.pull()

With an already-aborted `options.signal`, `push()`/`pull()` registered a raw consumer
(cursor) and then returned a rejecting iterable that never read or detached it. The
unreachable cursor inflates `consumerCount` and can impose backpressure forever.

## Hunks
1. `lib/internal/streams/iter/broadcast.js` (`push`): removed the early `signal?.aborted`
   return that came before `#createRawConsumer()`. Corresponds to the fix's broadcast.js
   hunk (the early rejecting-iterable return). The signal validation half is already done
   by `converters.PullOptions` in today's code, so only the early return was removed.
2. `lib/internal/streams/iter/share.js` (`pull`): same removal; corresponds to the
   share.js hunk.
3. `lib/internal/streams/iter/pull.js` (`pullWithConsumerCleanup`): removed
   `closeSource('throw', signal.reason)` in the pre-aborted branch. Today's code gained a
   cleanup helper that would detach the consumer and mask the bug (the fix's era used
   `pullWithTransforms`, which never detached it). Without this, removing hunks 1-2 alone
   leaves all tests passing. This restores the "never read or detached" behaviour.

## Failing tests
- parallel/test-stream-iter-broadcast-basic (testPushPreAbortedSignalDoesNotAddConsumer)
- parallel/test-stream-iter-share-async (testSharePullPreAbortedSignalDoesNotAddConsumer)

Both fail with AssertionError `actual: 1, expected: 0` on `consumerCount`. Stable over
two runs. test-stream-iter-validation still passes.
