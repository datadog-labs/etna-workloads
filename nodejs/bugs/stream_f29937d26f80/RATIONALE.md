# Re-introduced bug
`from()` on a sync iterable source (e.g. `from([asyncGen()])`) used to accept nested async iterables / toAsyncStreamable values instead of rejecting them with ERR_INVALID_ARG_TYPE.

## Change
lib/internal/streams/iter/from.js, in `normalizeAsyncSource`: the call `normalizeAsyncValue(value, false, context, true)` now passes `true` for `allowNestedAsyncStreamables`. Corresponds to the fix hunk changing `normalizeAsyncValue(value)` to `normalizeAsyncValue(value, false)`. The rest of the fix (the parameter and rejection check) has since been refactored but is kept; passing `true` disables the rejection, restoring old behavior.

## Failing test
parallel/test-stream-iter-from-async: testFromSyncIterableRejectsNestedAsyncIterable / ...NestedToAsyncStreamable fail because the promise does not reject (assert.rejects: Missing expected rejection). Confirmed stable over two runs.
