# Re-introduced bug: SignTraits::DeriveBits swallows OpenSSL errors (nodejs/node#40794)

**Bug.** When signing fails inside OpenSSL (e.g. `crypto.sign('sha512','message', 512-bit RSA key)`),
`SignTraits::DeriveBits` returned `false` without surfacing the OpenSSL error. The caller only sees
a generic failure instead of `ERR_OSSL_RSA_DIGEST_TOO_BIG_FOR_RSA_KEY` / "digest too big for rsa key".

**Change (src/crypto/crypto_sig.cc, SignTraits::DeriveBits, Sign mode).** The release has been refactored
onto ncrypto, and the framework (`DeriveBitsJob::DoThreadPoolWork`) now calls `errors->Capture()` on a
`false` return. The fix's `CheckThrow(kSignPrivateKey)` calls on each failure path therefore map to
"leave the OpenSSL error queue intact". Re-introducing the defect means discarding it:
1. One-shot failure (`signOneShot`) — corresponds to the two `EVP_DigestSign` hunks: `ERR_clear_error()` before `return false`.
2. Non-one-shot failure (`sign`) — corresponds to the `EVP_DigestSignFinal` hunks: `ERR_clear_error()` before `return false`.
3. Prehashed fallback result (RSA retries via `SignPrehashed` and would recapture the error) —
   `if (!*out) ERR_clear_error();` so the error is also lost on that path (needed for RSA to show the bug).

**Failing test.** `parallel/test-crypto-sign-verify` -> `not ok` (stable over 2 runs):
expected code `ERR_OSSL_RSA_DIGEST_TOO_BIG_FOR_RSA_KEY`, got
`code: 'ERR_CRYPTO_OPERATION_FAILED', message: 'Deriving bits failed'`.
