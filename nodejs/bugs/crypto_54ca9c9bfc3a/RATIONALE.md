# Re-introduced bug: webcrypto AES generateKey() length validation error type

**Bug.** `subtle.generateKey()` for AES algorithms validated `algorithm.length` with
`validateInteger` + `validateOneOf`, so invalid lengths threw Node-style errors
(`ERR_INVALID_ARG_VALUE` / `ERR_INVALID_ARG_TYPE`) instead of the WebCrypto-mandated
`OperationError` DOMException.

**Change (lib/internal/crypto/aes.js)**, corresponding to the fix's hunks in `aesGenerateKey` and the validators import:
- Added `require('internal/validators')` import of `validateInteger`/`validateOneOf` and a `kAesKeyLengths = [128,192,256]` constant (reverses the removed import hunk; today's file no longer had the constant).
- At the start of `aesGenerateKey`, call `validateInteger(length, 'algorithm.length')` and `validateOneOf(length, 'algorithm.length', kAesKeyLengths)`, before the webidl-based `validateAlgorithm` (which now holds the OperationError check, replacing the fix's `ArrayPrototypeIncludes` + `lazyDOMException`). Running first restores the old error types.

**Failing test.** `parallel/test-webcrypto-keygen` fails (stable over 2 runs): `ERR_ASSERTION`, the AES invalid-length case got `code: 'ERR_INVALID_ARG_VALUE'` instead of `name: 'OperationError'`.
