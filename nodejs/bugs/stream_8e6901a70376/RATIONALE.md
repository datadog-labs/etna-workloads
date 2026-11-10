# Re-introduced bug: compose() does not always call _destroy on the tail stream

**Bug.** `compose()`'s `d._destroy` only destroyed the tail stream inside the branch where a close callback was still pending. When the composed stream is destroyed without a pending `onclose` callback, `callback(err)` ran and the tail (e.g. a user Duplex with its own `_destroy`) was never destroyed, so its `_destroy` was not called (nodejs/node#51987).

**Change (lib/internal/streams/compose.js, `d._destroy`).**
The fix moved `if (isNodeStream(tail)) destroyer(tail, err);` out of the `else` branch and ahead of the `if (onclose === null)` check. I moved it back into the `else` branch. A plain reversal was not enough. `onclose` starts as `undefined`, not `null`, so the `else` branch is always taken and the tail is still destroyed synchronously. I also changed the condition from `onclose === null` to `!onclose`, so the "no pending close" path, which skips the tail destroy, is also reached when `onclose` is unset. That is what the old code did when it was reached.

**Failing test.** `parallel/test-stream-compose` fails with `AssertionError [ERR_ASSERTION]: Expected values to be strictly equal`. This is the new test's `assert.strictEqual(duplex.destroyed, true)`. It failed on two consecutive runs.
