# Re-introduced bug: crypto.getHashes() advertises unsupported algorithms

**Bug.** `crypto.getHashes()` listed every name from OpenSSL's legacy `EVP_MD_do_all_sorted` table, including names that cannot actually be used (e.g. algorithms only used internally by OpenSSL 3). `crypto.createHash(name)` then threw `ERR_OSSL_EVP_UNSUPPORTED` for some listed names.

**Change (src/crypto/crypto_hash.cc, `SaveSupportedHashAlgorithmsAndCacheMD`).** The release no longer has `array_push_back`. The equivalent filter is the `EVP_MD_fetch` (via `FetchAndMaybeCacheMD`) check before `push_back`. This hunk corresponds to the fix's `array_push_back` hunk in crypto_util.h (the `EVP_*_fetch` filter) and the crypto_hash.cc hunk. I removed the check, so every legacy name is pushed unconditionally, as before the fix.

**Not changed.** The cipher hunk (crypto_cipher.cc). `getCiphers` now goes through `ncrypto::Cipher::ForEach` in deps/, outside the allowed scope.

**Failing test.** `parallel/test-crypto` fails at test-crypto.js:164 (`crypto.createHash(algo)` loop): `Error: error:0308010C:digital envelope routines::unsupported` (`ERR_OSSL_EVP_UNSUPPORTED`).
