# Re-introduced bug: getCertificate() frees an internal X509*

**Bug.** `SSL_get_certificate` returns an internal pointer that the caller must not free. The old code wrapped it in an owning smart pointer (`X509Pointer`), so each `tlsSocket.getCertificate()` call dropped a reference on the SSL's own certificate. Repeated calls left the certificate over-released, so the result was wrong (undefined fields) or crashed.

**Hunk (src/crypto/crypto_common.cc, `GetCert`).** This corresponds to the fix's only implementation hunk in `SSLWrap<Base>::GetCertificate`. That code now lives in `GetCert`, because `TLSWrap::GetCertificate` calls it. Today's code uses `ssl.getCertificate()`, which returns a non-owning view. I replaced it with `X509Pointer cert(SSL_get_certificate(ssl.get()))`, an owning pointer that frees the internal cert on scope exit. This matches the pre-fix `X509Pointer cert(SSL_get_certificate(...))`. The result is still passed to `X509Certificate::toObject` via `cert.view()`.

**Failing test.** `parallel/test-tls-pfx-authorizationerror` fails with this assertion, at test line 68 in the current test file:
`AssertionError: Expected values to be strictly equal: + actual - expected + undefined - '147D36C1C2F74206DE9FAB5F2226D78ADB00A426'`
(the `getCertificate().serialNumber` check).
