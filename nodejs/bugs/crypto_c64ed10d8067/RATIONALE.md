# Rationale

**Bug:** `createPrivateKey`/private-key consumers did not tell `parseKeyEncoding` that the input must be a private key, so `type: 'spki'` (public-only encoding) was accepted for private keys instead of being rejected with `ERR_INVALID_OPT_VALUE`/invalid `key.type`. The bad input reached OpenSSL, giving a generic "Failed to read private key" error (originally an abort, issue #29904).

**Change (lib/internal/crypto/keys.js, `prepareAsymmetricKeyOptions`):** corresponds to the fix's single hunk in `prepareAsymmetricKey`. Removed `const isPublic = isPrivateKeyInput ? false : undefined;` and pass `undefined` as `isPublic` to `parseKeyEncoding`, as before the fix, so the private-only type validation is skipped.

**Failing test:** `parallel/test-crypto-key-objects` fails: expected message "The property 'key.type' is invalid. Received 'spki'" but got 'Failed to read private key'.
