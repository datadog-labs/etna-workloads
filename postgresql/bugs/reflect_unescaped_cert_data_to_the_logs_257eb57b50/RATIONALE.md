# Rationale

**File/function:** src/backend/libpq/be-secure-openssl.c, `prepare_cert_name()` (called from `verify_cb`).

**Traces to:** the fix.patch hunk that made `prepare_cert_name` end with `return pg_clean_ascii(truncated, 0);`, where the old code returned the name without escaping. Today's code already has the palloc'd-return structure, so the reversal is only the final line. It is now `return pstrdup(truncated);`.

**Why it restores the bug:** the subject and issuer from an untrusted certificate are truncated but no longer have non-ASCII or unprintable bytes escaped. They go raw into the server log's "Failed certificate data" detail.

**Failing oracle case:**
- src/test/ssl|t/001_ssltests.pl|certificate authorization fails with revoked UTF-8 client cert with server-side CRL directory: log matches#2
