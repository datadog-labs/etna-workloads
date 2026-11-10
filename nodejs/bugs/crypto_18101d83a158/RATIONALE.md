# Re-introduced bug: dh/x25519/x448 accepted in Sign/Verify final (nodejs#53742)

Bug: signing/verifying with DH, X25519 or X448 keys did not throw "operation not supported for this keytype". `EVP_PKEY_sign_init`/`verify_init` return -2 for unsupported key types, and the return value was treated as truthy (sign) or the -2 was not mapped to an error (verify), so the failure was silently swallowed.

Changes (src/crypto/crypto_sig.cc), re-expressed for today's ncrypto wrappers:
1. `Node_SignFinal`: `pkctx.initForSign() > 0 &&` -> `pkctx.initForSign() &&`. Corresponds to the fix's `EVP_PKEY_sign_init(...) > 0` hunk; without `> 0`, -2 counts as success.
2. `Verify::VerifyFinal`: removed the `init_ret == -2 -> return Error::PublicKey` check and went back to a plain `if (pkctx.initForVerify() && ...)`. Corresponds to the fix's verify hunk; verification of unsupported key types no longer raises an error.

Failing test: parallel/test-crypto-sign-verify (not ok, ERR_ASSERTION: the expected ERR_OSSL_EVP_OPERATION_NOT_SUPPORTED_FOR_THIS_KEYTYPE error is not thrown). It failed on both runs.
