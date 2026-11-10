# Re-introduced bug: webcrypto ECDH JWK import checks `alg`

**Bug:** `importKey('jwk', ...)` for ECDH validated the JWK `alg` member (expecting ES256/ES384/ES512 matching the curve), although the Web Crypto spec only does so for ECDSA. Importing an ECDH JWK with `alg: 'ECDH-ES'` therefore failed.

**Change (lib/internal/crypto/ec.js, ecImportKey):** the condition `if (algorithm.name === 'ECDSA' && keyData.alg !== undefined)` was reverted to `if (keyData.alg !== undefined)`. This corresponds to the single implementation hunk of the fix (the code around it has changed since, but the line is the same), and restores the pre-fix behaviour of checking `alg` for all EC algorithms.

**Failing test:** parallel/test-webcrypto-export-import-ec ("not ok", stable across 2 runs); the new ECDH case with `alg: 'ECDH-ES'` is rejected with a DataError ('JWK "alg" does not match the requested algorithm').
