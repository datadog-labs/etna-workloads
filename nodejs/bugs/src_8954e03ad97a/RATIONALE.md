# Re-introduced bug: 0-length output crash in webcrypto (nodejs/node#38883)

**Bug:** `CipherJob::ToResult` treated an empty output buffer as a failure. When a WebCrypto cipher operation legitimately produced 0 bytes (e.g. AES-GCM decrypt of a tag-only ciphertext), it captured OpenSSL errors, found none, and hit `CHECK(!errors->Empty())`, aborting the process.

**Hunks:**
1. `src/crypto/crypto_cipher.h` (`CipherJob::ToResult`) corresponds to the fix's `crypto_cipher.h` hunk. I restored the old logic: success only when `out_.size() > 0`; otherwise capture errors and `CHECK(!errors->Empty())`. Today's code had been restructured (it branches on `errors->Empty()`), so I re-expressed the old logic in that structure.
2. The fix's `crypto_aes.cc` hunk (skip `EVP_CipherUpdate` when the input is empty) is not reverted. It only guards against old OpenSSL and is not needed to reproduce the crash. Reverting it would not change behaviour on this build.

**Failing test:** `parallel/test-crypto-subtle-zero-length` fails with `severity: crashed`, exit code -5, and a V8 fatal error ("Invoke in DisallowJavascriptExecutionScope") from `CryptoJob<AESCipherTraits>::AfterThreadPoolWork`. The test crashes on the 0-length decrypt; the failure was stable across two runs.
