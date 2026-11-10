# Re-introduced bug: X509Certificate.checkPrivateKey leaves OpenSSL errors queued

**Bug.** `X509Certificate.prototype.checkPrivateKey()` calls `X509_check_private_key()`. When the key does not match, OpenSSL pushes an error such as `EVP_R_DIFFERENT_KEY_TYPES` onto the error queue, and nothing clears it. The next crypto call that checks the queue, for example `createPrivateKey()`, then throws that stale error. This is nodejs/node#45485.

**Change.** The fix added `ClearErrorOnReturn clear_error_on_return;` in `X509Certificate::CheckPrivateKey` in `src/crypto/crypto_x509.cc`. In v26.13.0 that clearing happens inside `ncrypto::X509View::checkPrivateKey` in `deps/ncrypto`. I may not edit `deps/`, so I took the call out of ncrypto in `src/crypto/crypto_x509.cc`. `CheckPrivateKey` now calls `X509_check_private_key(cert->view().get(), key->Data().GetAsymmetricKey().get()) == 1` directly, with no `ClearErrorOnReturn`. That matches the pre-fix code, which also called `X509_check_private_key` with no clearing.

**Failing test.** `parallel/test-crypto-x509` fails with `not ok`, `code: 'ERR_OSSL_EVP_DIFFERENT_KEY_TYPES'`. The `createPrivateKey(key)` call that follows `x509.checkPrivateKey(keyPair.privateKey)` throws the stale error. I ran the test twice and it failed both times.
