# Re-introduced bug: webcrypto JWK EC/OKP import lacks `crv` check

Bug: importing a JWK for EC or OKP (Ed25519/Ed448/X25519/X448) keys did not verify that the JWK's `crv` member matched the requested algorithm's namedCurve/name, so a mismatched or missing `crv` was not rejected up front.

Hunks (the fix's `curve` -> `algNamedCurve` rename already exists in today's code and is left as is):
- lib/internal/crypto/ec.js: removed the `keyData.crv !== namedCurve` check in the 'jwk' branch. Corresponds to the fix hunk that added it (today's message is 'JWK "crv" does not match the requested algorithm').
- lib/internal/crypto/cfrg.js: removed the `keyData.crv !== name` check in the 'jwk' branch. Corresponds to the fix hunk adding the 'Subtype mismatch' check.

Failing tests (both, stable across 2 runs):
- parallel/test-webcrypto-export-import-cfrg: expected message 'JWK "crv" Parameter and algorithm name mismatch', got 'Invalid key type'.
- parallel/test-webcrypto-export-import-ec: expected 'JWK "crv" does not match the requested algorithm', got 'Invalid keyData'.
