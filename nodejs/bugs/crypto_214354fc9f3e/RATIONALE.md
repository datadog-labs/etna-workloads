# Bug
WebCrypto HMAC default key length (when `length` is omitted) used the hash output size (160/256/384/512) instead of the hash block size (512/512/1024/1024) in `generateKey` and `deriveKey`.

# Changes (lib only)
- lib/internal/crypto/util.js: `getBlockSize` -> `getHashLength` returning 160/256/384/512 for SHA-1/256/384/512 (SHA3 throw kept). Matches the fix's util.js hunk (reversed); export renamed too.
- lib/internal/crypto/mac.js: `hmacGenerateKey` default length uses `getHashLength` (fix's mac.js hunk, reversed).
- lib/internal/crypto/webcrypto.js: `getKeyLength` HMAC default uses `getHashLength` (fix's webcrypto.js hunk, reversed; value now equals old hardcoded switch).

# Failing tests
parallel/test-webcrypto-keygen and parallel/test-webcrypto-derivekey: derived/generated HMAC `algorithm.length` is 160/256/384/512 rather than the expected 512/512/1024/1024 (assertion failure).
