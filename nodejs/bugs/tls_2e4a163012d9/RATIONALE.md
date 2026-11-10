# Rationale

**Bug:** The `ca:` option of `tls.createSecureContext()` parsed PEM with `PEM_read_bio_X509`, which only accepts `BEGIN CERTIFICATE` blocks. `BEGIN TRUSTED CERTIFICATE` blocks (accepted by openssl for a CAfile) were not loaded, so the CA was missing and client verification failed.

**Change:** `src/crypto/crypto_tls_certificates.cc`, `AddCACertificates`: `PEM_read_bio_X509_AUX` -> `PEM_read_bio_X509`. This corresponds to the fix's single hunk in `SecureContext::AddCACert`. That code now lives in this function.

**Failing test:** `parallel/test-tls-client-auth` reports "not ok". The "BEGIN TRUSTED CERTIFICATE" cases now return `UNABLE_TO_GET_ISSUER_CERT_LOCALLY` / `ECONNRESET` errors, so `assert.ifError(err)` fails.
