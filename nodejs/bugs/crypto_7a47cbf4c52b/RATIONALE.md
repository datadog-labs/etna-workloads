# Re-introduced bug: RsaHashedKeyGenParams.publicExponent not normalized

**Bug.** `publicExponent` passed to `subtle.generateKey()` for RSA algorithms was not normalized to a fresh
`Uint8Array`; the resulting `CryptoKey.algorithm.publicExponent` was the caller's own object (e.g. a `Buffer`, the same reference).

**Hunks** (the release no longer copies in only one place, so the fix's single hunk maps to four):
1. `lib/internal/crypto/util.js`: dropped `publicExponent: 'BufferSource'` from `simpleAlgorithmDictionaries.RsaHashedKeyGenParams` (the exact reverse of the fix hunk), so `normalizeAlgorithm` no longer copies it.
2. `lib/internal/crypto/rsa.js` (`rsaKeyGenerate`): the key algorithm stores `publicExponent` as given instead of a new `Uint8Array` view (also removed the leading-zero stripping and now-unused imports). This wrapping hid the bug after the plain reversal.
3. `lib/internal/crypto/keys.js` (`cloneAlgorithm`) and 4. (`cloneInternalAlgorithm`): removed the `new Uint8Array(publicExponent)` copy. This is the later normalization point that also masked the reversal.

Together, `algorithm.publicExponent` is again the user's object, as before the fix.

**Failing test.** `parallel/test-webcrypto-keygen` (stable over 2 runs):
`AssertionError: Expected "actual" not to be reference-equal to "expected"` (operator `notStrictEqual`, actual `Buffer(3) [1, 0, 1]`).
