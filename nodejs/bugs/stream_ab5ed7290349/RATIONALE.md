# Re-introduced bug: stream/iter consumers don't observe abort while a read is pending

## Bug
`bytes()`, `text()`, `arrayBuffer()` and `array()` (via `collectAsync` in
`lib/internal/streams/iter/consumers.js`) only checked `signal.throwIfAborted()` between
batches. If the source's `next()` was pending (never resolving), aborting the signal
did nothing and the consumer promise never rejected with the abort reason.

## Change
One hunk, in `collectAsync` in `lib/internal/streams/iter/consumers.js`. It corresponds to
the fix's second `consumers.js` hunk (`const iterable = signal ? yieldAbortable(normalized, signal) : normalized;`
and `for await (const batch of iterable)`). I removed the `yieldAbortable` wrapper, so the slow
path is back to `for await (const batch of normalized)`. Pending reads are no longer raced against the abort signal.

The fix's first `consumers.js` hunk wrapped the source in `yieldAbortable` before `from()`. The release's
`collectAsync` already lacks that wrapper, so there was nothing to revert there. The move of
`yieldAbortable` from `pull.js` to `utils.js` is a refactor. It is still needed by
`pull`, `broadcast` and other consumers, so I left it alone.

## Failing test
`parallel/test-stream-iter-consumers-bytes` fails (`not ok`) on both runs.
`testAsyncConsumersAbortPendingNext` never settles, because the promise stays pending after
abort. The process exits and the test reports:
`Mismatched noop function calls. Expected exactly 1, actual 0.`
