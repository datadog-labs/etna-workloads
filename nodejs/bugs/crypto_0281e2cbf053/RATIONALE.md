# Re-introduced bug: scrypt "memory limit exceeded" not propagated

**Bug:** When `ncrypto::checkScryptParams` fails (e.g. `maxmem` too small), Node threw only the generic
`ERR_CRYPTO_INVALID_SCRYPT_PARAMS` ("Invalid scrypt params") and dropped the OpenSSL error
(e.g. "memory limit exceeded"), making maxmem problems hard to diagnose.

**Change (src/crypto/crypto_scrypt.cc, `ScryptTraits::AdditionalConfig`):** Corresponds to the single
implementation hunk of the fix. The release now calls `ncrypto::checkScryptParams` rather than
`EVP_PBE_scrypt` directly, so I removed the `ERR_peek_last_error()` / `ERR_error_string_n` block and
restored the bare `THROW_ERR_CRYPTO_INVALID_SCRYPT_PARAMS(env);`, which is the pre-fix behaviour.

**Failing test:** `parallel/test-crypto-scrypt` fails (stable over 2 runs): expected message
`/Invalid scrypt params:.*memory limit exceeded/`, actual `'Invalid scrypt params'`.
