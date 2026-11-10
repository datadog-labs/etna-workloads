# Re-introduce DEP0182 (implicit short GCM auth tags accepted again)

**Bug.** Before upstream commit dff46c07, `createDecipheriv('aes-256-gcm', ...)` without `authTagLength` accepted
any valid GCM tag length (4, 8, 12..16 bytes) in `setAuthTag()`, only emitting a DEP0182 deprecation warning for tags
shorter than 128 bits. The fix made this an error (End-of-Life). With the bug, short tags weaken authentication silently.

**Hunks (all in src/crypto/crypto_cipher.cc).**
1. `CipherBase::InitIv`: for GCM decipher with no explicit tag length, leave `auth_tag_len_` as `kNoAuthTagLength`
   instead of defaulting to 16. (Today's code defaults at init; the original fix's context had no such default, so
   this restores the "unset" state that the pre-fix `SetAuthTag` relied on.)
2. `CipherBase::SetAuthTag`: replaces the strict `auth_tag_len_ != tag_len` check with the pre-fix logic. This
   corresponds to the fix hunk that removed the `tag_len != EVP_GCM_TLS_TAG_LEN` rejection and re-adds the
   `is_valid` computation plus the DEP0182 `ProcessEmitDeprecationWarning`.

**Failing test.** `parallel/test-crypto-gcm-implicit-short-tag` fails (stable over 2 runs): `assert.throws` expected
`{ message: 'Invalid authentication tag length: 4' }` but no error is thrown (a deprecation warning is emitted instead).
