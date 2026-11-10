# Re-introduced bug: multi-prime RSA JWK export drops `oth`

**Bug:** private multi-prime RSA keys exported as JWK lose the additional prime information (the `oth` array with `r`, `d`, `t`). The exported JWK only has p/q/dp/dq/qi, so it cannot represent the full key.

**Change (src/crypto/crypto_rsa.cc, ExportJWKRsaKey):** removed the block that reads `rsa.getOtherPrimeInfos()` and defines the `oth` property. This corresponds to the first `crypto_rsa.cc` export hunk of the fix, which added that block. I did not touch the import-side hunks or the `env_properties.h` strings. The import code for `oth` is harmless without export, and the strings are unused-but-valid.

**Failing test:** `parallel/test-crypto-rsa-multiprime-jwk` reports `not ok` on two consecutive runs. The assertion `jwk.oth.length` throws because `jwk.oth` is undefined.
