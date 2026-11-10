# Re-introduced bug: crypto hash/hmac `digest('ucs2')` arbitrarily rejected

**Bug.** `hash.digest()` and `hmac.digest()` threw `ERR_CRYPTO_HASH_DIGEST_NO_UTF16` for any UTF-16 output encoding (`ucs2`, `utf16le`, ...), although the native layer can encode it. The fix removed this restriction.

**Hunks (lib/ only; src/ needs none).**
- `lib/internal/crypto/hash.js`: `Hash.prototype.digest` and `Hmac.prototype.digest` re-gain the `normalizeEncoding(outputEncoding) === 'utf16le'` check that throws (fix hunks 2 and 3). Today's code has no default-encoding line, so the check is placed at the top (after the finalized check for Hash). `normalizeEncoding` is already imported in the file. The error is added to the destructured imports (fix hunk 1).
- `lib/internal/errors.js`: re-adds `ERR_CRYPTO_HASH_DIGEST_NO_UTF16` (fix hunk 4).
- The `CHECK_NE(encoding, UCS2)` hunk in C++ has no counterpart: that line no longer exists in the release's `src/crypto/crypto_hmac.cc`, and the JS check makes it unreachable anyway.

**Failing tests.** `parallel/test-crypto-hash` and `parallel/test-crypto-hmac` both report `not ok`. Both `digest('ucs2')` assertions now throw `ERR_CRYPTO_HASH_DIGEST_NO_UTF16` ("hash.digest() does not support UTF-16") instead of returning the string. Both failed on two runs.
