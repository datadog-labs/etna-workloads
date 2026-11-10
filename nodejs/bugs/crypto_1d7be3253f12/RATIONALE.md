# Rationale

**Bug:** `crypto.timingSafeEqual` validation (argument types, equal byte length) was not done in the C++ binding, so the native function trusted its callers (upstream: validation lived in a JS wrapper, which proved fragile under V8 inlining, nodejs/node#34073). Direct calls with unequal lengths hit a fatal `CHECK_EQ` and abort the process instead of throwing `ERR_CRYPTO_TIMING_SAFE_EQUAL_LENGTH`; non-buffer args are not rejected with `ERR_INVALID_ARG_TYPE`.

**Change (src/crypto/crypto_timing.cc, slow-path `TimingSafeEqual`):**
- Removed the two `IsAnyBufferSource` checks that throw `ERR_INVALID_ARG_TYPE` (reverse of the fix hunk adding type checks to C++).
- Replaced the `THROW_ERR_CRYPTO_TIMING_SAFE_EQUAL_LENGTH` length check with `CHECK_EQ(buf1.size(), buf2.size())` (reverse of the hunk that replaced `CHECK_EQ` with a throw).
The JS wrapper and error-table hunks of the fix are not re-expressed: today the JS side is already the bare binding (`lib/crypto.js` uses the binding directly), so only the C++ hunk applies.

**Failing test:** `sequential/test-crypto-timing-safe-equal` crashes (exit -6): `Assertion failed: (buf1.size()) == (buf2.size())` at crypto_timing.cc, from the length-mismatch assertion. Stable across runs.
