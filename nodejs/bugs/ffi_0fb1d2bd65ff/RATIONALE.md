# Bug
Fast-API FFI calls did not range-check narrow integer (i8/u8/i16/u16/bool/char) and 64-bit BigInt (i64/u64) arguments, so out-of-range values were silently truncated or wrapped by V8's Fast API instead of throwing like the generic path.

# Change
Single hunk in `lib/internal/ffi/fast-api.js`, `validateAndConvertFastIntegerArg`: the check `!validType || value < info.min || value > info.max` was reduced to `!validType`. This corresponds to the fix's `validateFastIntegerArg` hunk (the range comparison it added). The surrounding wrapper plumbing (type table, index selection, C++ `SignatureNeedsFastIntegerValidation`) exists in the release in reshaped form; it was left in place, so only the range validation is lost, which restores the pre-fix behaviour (type check only).

# Failing test
`ffi/test-ffi-fast-integer-validation` -> `not ok` (e.g. `callI8(128)` no longer throws ERR_INVALID_ARG_VALUE). Failed in two consecutive runs.
