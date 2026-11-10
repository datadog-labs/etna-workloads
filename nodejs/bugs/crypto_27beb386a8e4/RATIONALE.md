# Re-introduced bug: scrypt keylen validation

**Bug:** `crypto.scrypt`/`scryptSync` validated `keylen` as a uint32 (0..4294967295) rather than an int32 (0..2147483647). Values like 2147485780 passed JS validation instead of throwing `ERR_OUT_OF_RANGE`, and reached the native layer, where they overflow (issue #38381).

**Change (lib/internal/crypto/scrypt.js):**
- `check()`: `validateInt32(keylen, 'keylen', 0)` -> `validateUint32(keylen, 'keylen')`. This reverses the fix's one-line change.
- Removed the `validateInt32` import, which the fix added and which would otherwise be unused.

**Failing test:** `parallel/test-crypto-scrypt` fails. The new bad-arg case `['', '', 2147485780]` no longer throws ERR_OUT_OF_RANGE on `"keylen"`. The assertion reports actual `ERR_INVALID_ARG_TYPE` ('The "callback" argument must be of type function. Received undefined') instead of expected `ERR_OUT_OF_RANGE` /"keylen"/. The test file was left unmodified, and it already contains the fix's case.
