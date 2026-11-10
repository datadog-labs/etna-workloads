# Bug
Stream operators (`map`/`flatMap`/`filter`, `reduce`, `toArray`, `drop`, `take`) in lib/internal/streams/operators.js no longer validate `options.signal`. A non-AbortSignal (e.g. `{ signal: true }`) is silently accepted instead of throwing `ERR_INVALID_ARG_TYPE`.

# Changes (lib/internal/streams/operators.js)
The fix added `validateAbortSignal(options.signal, 'options.signal')` guarded by `options?.signal != null` to map, asIndexedPairs, some, reduce, toArray, drop and take. Today the code already has the sync/async structure from the fix, so only the signal-validation hunks are reversed:
- map, reduce, toArray, drop, take: removed the `if (options?.signal != null) validateAbortSignal(...)` block.
- Removed the now-unused `validateAbortSignal` import (corresponds to the import hunk).
- asIndexedPairs/some have no such hunk in today's code (asIndexedPairs removed; some delegates to filter -> map, so it is covered by the map change).

# Failing tests
test-stream-map, test-stream-flatMap, test-stream-drop-take: "Missing expected exception" (expected /ERR_INVALID_ARG_TYPE/) for `{ signal: true }`; test-stream-reduce: rejection doesn't match /ERR_INVALID_ARG_TYPE/; test-stream-toArray also fails. Ran twice, stable.
