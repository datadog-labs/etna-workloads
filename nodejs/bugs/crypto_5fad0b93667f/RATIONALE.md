# Re-introduced bug: webcrypto import of CFRG raw public keys

**Bug:** `subtle.importKey('raw', ...)` for Ed25519/Ed448/X25519/X448 treated the raw bytes as an EC public key (curve named after the algorithm) instead of a CFRG key, so importing valid raw CFRG public keys failed.

**Hunk (lib/internal/crypto/cfrg.js, `case 'raw'` in `cfrgImportKey`)** corresponds to the fix hunk changing `createECPublicKeyRaw(name, keyData)` to `createCFRGRawKey(name, keyData, true)`. In today's code that helper no longer exists; raw import goes through `importRawKey(true, keyData, kKeyFormatRawPublic, <keyTypeName>)`. I changed the key type name from the lowercase algorithm name to `'ec'` with the algorithm name passed as the namedCurve, i.e. the EC raw import path as before the fix.

**Failing test:** parallel/test-webcrypto-export-import-cfrg (fails on both runs):
`DOMException [DataError]: Invalid keyData  [cause]: TypeError: Invalid EC curve name`
