# Rationale

Bug: when creating an AEAD cipher with an invalid `authTagLength` (e.g. 0 or 17 for chacha20-poly1305), the thrown ERR_CRYPTO_INVALID_AUTH_TAG error had only the generic message "Invalid authentication tag" and no mention of the length.

Change: in `src/crypto/crypto_cipher.cc`, `CipherBase::InitAuthenticated`, the `is_invalid_auth_tag_length` branch now calls `THROW_ERR_CRYPTO_INVALID_AUTH_TAG(env())` without the "Invalid authentication tag length: %u" message. This corresponds to the single implementation hunk of the fix (the code moved from a direct EVP_CIPHER_CTX_ctrl check to ctx_.setAeadTagLength, but the same throw site).

Failing test: parallel/test-crypto-authenticated ("not ok"): expected message /Invalid authentication tag length/, actual 'Invalid authentication tag'. Stable across two runs.
