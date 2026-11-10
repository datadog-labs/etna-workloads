# Re-introduced bug: tls ciphers option rejects null

**Bug:** `ciphers: null` in TLS options was rejected with ERR_INVALID_ARG_TYPE instead of being treated like `undefined` (default ciphers).

**Hunk:** `lib/internal/tls/secure-context.js` (the code moved from `lib/_tls_common.js`): `if (ciphers !== undefined && ciphers !== null) validateString(...)` became `if (ciphers !== undefined) validateString(...)`. This corresponds to the fix's `ciphers != null` -> `ciphers !== undefined` in `createSecureContext`, so null reaches validateString and throws.

**Failing test:** `parallel/test-tls-set-ciphers` — `not ok`: `The "options.ciphers" property must be of type string. Received null` (from the null-ciphers cases). Stable across 2 runs.
