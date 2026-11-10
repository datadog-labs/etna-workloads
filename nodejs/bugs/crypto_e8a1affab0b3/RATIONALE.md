# CVE-2023-30588: X509Certificate.publicKey aborts on invalid SPKI

**Bug:** `X509Certificate.prototype.publicKey` converts the certificate's SPKI to a KeyObject. If the subjectPublicKey bit string is not a valid key, `X509_get_pubkey` fails and returns null. Nothing checks that result, so the null key reaches `KeyObjectData::CreateAsymmetric`. That function has `CHECK(pkey)`, so the process aborts instead of throwing a JS error.

**Change (src/crypto/crypto_x509.cc, `PublicKey`):** I removed the `if (!result.value) { ThrowCryptoError(...); return; }` block after `cert->view().getPublicKey()`. This corresponds to the fix's added `if (!pkey) return ThrowCryptoError(env, ERR_get_error());`. The release uses `view().getPublicKey()` where the fix used `X509_get_pubkey` directly. The fix's `ClearErrorOnReturn` has no counterpart here, because that line only matters when the error check exists. I left it alone.

**Failing test:** `parallel/test-crypto-x509` now fails. The new test accesses `cert.publicKey` on the invalid-SPKI certificate, and the process aborts with `Assertion failed: pkey` in `KeyObjectData::CreateAsymmetric` (crypto_keys.cc:1078). I ran it twice and it failed both times.
