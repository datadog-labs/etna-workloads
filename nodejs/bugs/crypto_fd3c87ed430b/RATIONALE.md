# Rationale

Bug: a malformed but present subjectAltName extension was indistinguishable from an absent one. `GetSubjectAltNameString` returned `undefined` for both. `X509Certificate#subjectAltName` therefore did not throw, and the legacy object (`getPeerCertificate()`) had no `subjectaltname`. TLS hostname checks could then fall back to the commonName after a malformed SAN. The exponent formatting also ignored BIO/BN_print failures.

Hunks (src/crypto/crypto_x509.cc):
1. `GetSubjectAltNameString`: reverts the fix's hunk that throws or returns the "DNS:" sentinel when the extension is present but cannot be formatted. It now always returns `undefined` when there is no BIO. The signature and enum remain, so the callers are unchanged.
2. `GetExponentString`: reverts the fix's atomic-write hunk. It goes back to unchecked `BIO_puts` and `BN_print`, and the `MarkPopErrorOnReturn` guard stays.

Other fix hunks (ncrypto changes, name-object, time and curve guards) are not reverted. They depend on ncrypto APIs that live outside src/ and lib/.

Failing tests with this change:
- parallel/test-crypto-x509: "Missing expected exception" (expected `ERR_CRYPTO_OPERATION_FAILED` from `.subjectAltName`).
- parallel/test-tls-cert-ext-encoding: `subjectaltname` is `undefined`, expected `'DNS:'`.

I ran both tests twice and they failed both times. parallel/test-crypto-x509-name-non-string still passes. I did not run the cctest cases.
