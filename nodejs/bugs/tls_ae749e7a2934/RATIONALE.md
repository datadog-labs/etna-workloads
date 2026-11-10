# Rationale

**Bug:** the cipher-list filter in createSecureContext no longer drops empty entries produced by splitting on ':'. A value like ':' yields cipherList '' ... actually ['', ''] joined to ':' (non-empty), so the "both lists empty" check (ERR_INVALID_ARG_VALUE) is bypassed and the error surfaces later as ERR_SSL_NO_CIPHER_MATCH; empty segments are also forwarded to OpenSSL.

**Hunk:** `lib/internal/tls/secure-context.js` (`processCiphers`, cipherList filter): removed `if (cipher.length === 0) return false;`. This corresponds to the fix's added `_.length > 0` in `lib/_tls_common.js` (code has since moved to this file). The cipherSuites filter's equivalent check is redundant (empty strings never match TLS_), so it was left alone.

**Failing test:** parallel/test-tls-set-ciphers — `actual: 'ERR_SSL_NO_CIPHER_MATCH', expected: 'ERR_INVALID_ARG_VALUE'` (the `':'` invalid-value cases). Stable across two runs.
