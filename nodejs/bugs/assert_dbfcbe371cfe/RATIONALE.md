# Bug
`assert.partialDeepStrictEqual` did not distinguish ArrayBuffer from SharedArrayBuffer: comparing e.g. `new ArrayBuffer(3)` with `new SharedArrayBuffer(3)` succeeded instead of throwing.

# Change
The fix's code (lib/assert.js compareBranch) no longer exists; partial comparison now lives in `lib/internal/util/comparisons.js`. The single hunk, in the `isAnyArrayBuffer(val1)` branch, skips the `hasUnequalTag` check when `mode === kPartial`. This corresponds to the fix's `partiallyCompareArrayBuffersOrViews` rejecting AB vs SAB ("Cannot compare ArrayBuffers with SharedArrayBuffers"); removing that rejection restores the pre-fix behaviour for partial mode only (strict/loose unchanged).

# Failing test
parallel/test-assert-typedarray-deepequal: `not ok` (the notEqualArrayPairs case `[new ArrayBuffer(3), new SharedArrayBuffer(3)]` no longer throws AssertionError from partialDeepStrictEqual). Stable over two runs.
