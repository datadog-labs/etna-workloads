# Re-introduced bug: fast FFI pointer BigInt range not validated

Optimized V8 fast API calls truncate out-of-range pointer BigInts (negative or > uintptrMax). The fix added
validation in `lib/internal/ffi/fast-api.js` so optimized calls throw `ERR_INVALID_ARG_VALUE` like the generic path.
With the bug, out-of-range values (-1n, 2n**64n+5n) are silently accepted/truncated.

## Changes (lib/internal/ffi/fast-api.js)
- Removed `validateFastPointerArg()` and its call in `convertPointerArg` (fix hunk 2/3: multi-arg path).
- Removed the call in the single-argument wrapper in `wrapWithRawPointerConversions` (fix hunk 4; in today's code it follows `validateAndConvertFastIntegerArg`).
- Removed the now-unused `uintptrMax` import (fix hunk 1). The C++ comment-only hunk in src/node_ffi.cc was not reproduced (comment only).

## Failing test
`ffi/test-ffi-fast-integer-validation` — "not ok" (assert.throws with `operator: 'throws'`: the missing exception for
`call(-1n)` / `call(2n**64n+5n)` in the 'fast FFI validates pointer BigInt ranges' subtest). Stable across 2 runs.
