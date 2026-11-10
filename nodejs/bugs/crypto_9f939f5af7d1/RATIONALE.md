# Re-introduced bug: Sign/Verify accept Ed25519/Ed448 keys

Ed25519/Ed448 are one-shot-only algorithms. Before the fix, `crypto.createSign().sign(key)` and
`createVerify().verify(key, sig)` did not reject such keys up front; they went on to OpenSSL and failed with a
raw error ("invalid eddsa instance for attempted operation") instead of `ERR_CRYPTO_UNSUPPORTED_OPERATION`.

## Hunks (src/crypto/crypto_sig.cc)
1. `Sign::SignFinal`: removed the `key.getAlgorithm()->isOneShot()` check + `THROW_ERR_CRYPTO_UNSUPPORTED_OPERATION`
   (today's form of the fix's `if (IsOneShot(key)) throw` hunk).
2. `Verify::VerifyFinal`: removed the equivalent check (fix's second hunk).

## Failing test
`parallel/test-crypto-sign-verify` fails: expected message 'Unsupported crypto operation', actual
'error:1C8000F3:Provider routines::invalid eddsa instance for attempted operation'. Stable across runs.
