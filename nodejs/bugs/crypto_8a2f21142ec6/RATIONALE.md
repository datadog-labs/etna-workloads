# Re-introduced bug: X25519/X448 public CryptoKey usages (fix 8a2f21142ec6)

**Bug.** WebCrypto X25519/X448 public keys were allowed to carry `deriveKey`/`deriveBits` usages. Per spec, public keys must have empty usages. Importing a public key (spki/jwk) with derive usages succeeded instead of throwing `SyntaxError`, and public keys got derive usages. Derive operations on public keys were also no longer rejected with `InvalidAccessError`.

**Change (lib/internal/crypto/cfrg.js, one hunk).** The fix's hunk set `checkSet = []` for public X25519/X448 keys and derive usages for private keys (in `verifyAcceptableCfrgKeyUse`). That function no longer exists. Usages now live in `createKeyUsages(publicUsages, privateUsages)`. I changed `kDeriveUsages` so its `public` list is `['deriveKey','deriveBits']` again (previously `[]`). `keygen` stays private-only, so `generateKey` doesn't see duplicate usages. This restores the pre-fix behaviour where public keys accept derive usages.

**Failing tests (stable over repeated runs).**
- parallel/test-webcrypto-export-import-cfrg: `AssertionError`. Actual was `DataError: Duplicate key operation`, expected `SyntaxError /Unsupported key usage/`. Importing a public X448 JWK with a derive usage is no longer rejected for usage.
- parallel/test-webcrypto-derivekey-cfrg: fatal crash (`Invoke in DisallowJavascriptExecutionScope`). A public key now passes as a derive base key and reaches the native DH job.
- parallel/test-webcrypto-derivebits-cfrg: `not ok`, same cause as derivekey.
