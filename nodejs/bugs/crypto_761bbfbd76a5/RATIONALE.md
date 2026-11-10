# Rationale

**Bug.** The JS validation layer for crypto KDFs used the wrong integer validator relative to what the native layer
assumed (upstream: `INT_MAX` was undefined; `validateInt32` was used where the native layer assumes `uint32_t`).
In today's tree the native layer asserts `IsInt32()`, so validating keylen/iterations with `validateUint32` lets values in
[2^31, 2^32) pass JS validation and reach the native binding, which aborts the process instead of a clean `ERR_OUT_OF_RANGE`.

The fix's hunks no longer apply literally (INT_MAX is gone; code was rewritten), so they were re-expressed:

- `lib/internal/crypto/pbkdf2.js` (fix hunk: validateInt32 -> validateUint32 for iterations/keylen): `check()` now uses
  `validateUint32` for `iterations` and `keylen`; import changed accordingly.
- `lib/internal/crypto/scrypt.js` (fix hunk: validateInt32 -> validateUint32 for scrypt keylen): `keylen` uses
  `validateUint32`; unused `validateInt32` import removed.

**Failing test:** `parallel/test-crypto-pbkdf2` — crashed (exit -6), `Assertion failed: args[offset + 2]->IsInt32()`
in `PBKDF2Traits::AdditionalConfig` when `keylen = 2147483648` is passed to `pbkdf2Sync`.
