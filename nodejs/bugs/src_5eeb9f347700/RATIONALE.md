# Re-introduced bug: CVE-2025-23166 (async crypto error handling)

**Bug.** Async crypto jobs (`DeriveBitsJob`, e.g. `crypto.sign`/`crypto.verify` with a callback) run `DeriveBits` on a thread-pool thread. Error handling that touches V8 (`CheckThrow`, which throws a JS exception) was run there too, and OpenSSL's error queue was not cleared on return. This crashes the process (SIGSEGV) instead of delivering the error to the callback.

**Today's code differs from the fix.** The fix's `CryptoJobMode mode` parameter already exists, as does a `CryptoErrorStore*` parameter. DH, ECDH and the other traits no longer throw. So the plain reversal doesn't apply, and only the Sign and job hunks are re-expressed.

## Hunks
1. `src/crypto/crypto_util.h`, `DeriveBitsJob::DoThreadPoolWork`: removed `ncrypto::ClearErrorOnReturn`. This reverses the fix's `ClearErrorOnReturn clear_error_on_return;` addition.
2. `src/crypto/crypto_sig.cc`, `SignTraits::DeriveBits`: re-added unconditional `crypto::CheckThrow(...)` calls on the init failure, the `ApplyRSAOptions` failure and the `context.sign` failure. This reverses the fix's `if (can_throw)` guards, which only throw in sync mode. The fix did not touch the one-shot and prehash paths, so I left them alone.

## Result
`parallel/test-crypto-async-sign-verify` crashes with exit code -11 (severity: crashed) and reports `not ok`. The cause is the thread-pool throw in the new async verify/sign error cases. It fails on both runs.
