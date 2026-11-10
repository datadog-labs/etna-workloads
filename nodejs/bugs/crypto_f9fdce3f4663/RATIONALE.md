# Re-introduced bug: HMAC rejects the "dss1"/"DSS1" SHA-1 aliases

**Bug.** Before the fix, `crypto.createHmac('dss1' | 'DSS1', key)` failed with `Invalid digest: dss1`. These names are historical SHA-1 aliases and are accepted elsewhere (`createHash`). The fix's test checks that HMAC with them equals HMAC-SHA1.

**Why the plain reversal fails.** The fix's src hunks are the `OPENSSL_WITH_KMAC` -> `OPENSSL_WITH_EVP_MAC` rename and a constructor init cleanup. They change no behaviour. In this release the EVP_MAC HMAC backend and the dss1 alias handling (`ncrypto::getDigestByName`) both live in deps/ncrypto, which is off limits here.

**Change (src/crypto/crypto_hmac.cc, `Hmac::HmacInit`).** There is no matching hunk in the fix. It is a re-expression of the old behaviour. The digest is now resolved with `Digest::Fetch` and then raw `EVP_get_digestbyname`, which bypasses `getDigestByName`'s dss1/DSS1 -> SHA-1 mapping. As a result, dss1 is unknown for HMAC and throws `ERR_CRYPTO_INVALID_DIGEST`.

**Failing test.** `parallel/test-crypto-hmac` fails with `TypeError: Invalid digest: dss1`. It failed on repeated runs.
