# Re-introduced bug: PBKDF2 args validated as uint32 instead of int32

**Bug:** `crypto.pbkdf2`/`pbkdf2Sync` validated `iterations` and `keylen` only as unsigned 32-bit integers. OpenSSL (and node's C++) use signed ints, so values in 2^31..2^32-1 passed JS validation but overflowed to negative in C++ (nodejs/node#44570).

**Hunks** (all in `lib/internal/crypto/pbkdf2.js`):
1. Import: `validateInt32` replaced by `validateUint32` (reverses the fix's import hunk).
2. `check()`: `validateInt32(iterations, 'iterations', 1)` / `validateInt32(keylen, 'keylen', 0)` (and the comment) reverted to `validateUint32(iterations, 'iterations', true)` / `validateUint32(keylen, 'keylen')`. The surrounding code changed since the fix (`isInt32` import, `keylen += 0`), so these were left as is.

**Failing test:** `parallel/test-crypto-pbkdf2` reports `not ok`. The test expects ERR_OUT_OF_RANGE for iterations 2147483648 and keylen 2147483648/4294967296 boundary values, which are no longer rejected by the JS validation.
