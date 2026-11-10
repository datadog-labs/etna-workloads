# Rationale

**Bug:** Fast-API integer validation did not cover 32-bit integer args (i32/int32/u32/uint32). Optimized calls let V8 coerce/truncate out-of-range, fractional or string values instead of throwing.

**Hunks**
- `lib/internal/ffi/fast-api.js`: removed the `int32`, `uint32`, `i32`, `u32` entries from `fastIntegerTypeInfo` (corresponds to the fix's JS hunk, which added them; today's table has them in two groups).
- `src/ffi/fast.cc`: removed `int32/uint32/i32/u32` from `SignatureNeedsFastIntegerValidation` (corresponds to the fix's C++ hunk; reflowed for today's layout), so 32-bit-only signatures skip the JS range check.

**Failing test:** `ffi/test-ffi-fast-integer-validation` — "not ok" with `AssertionError [ERR_ASSERTION]: Missing expected exception` (e.g. callI32(2147483648) doesn't throw). Stable across 2 runs.
