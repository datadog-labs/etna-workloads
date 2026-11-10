# Rationale

**Bug:** `X509Certificate.prototype.toLegacyObject()` did not return a real legacy
certificate object. It returned the raw binding result, instead of passing it through
`translatePeerCertificate`. Fields such as `subject`, `issuer` and `infoAccess` therefore
differed from what `tls.TLSSocket#getPeerCertificate()` returns.

**Change (lib/internal/crypto/x509.js only):** `toLegacyObject()` now returns
`FunctionPrototypeCall(nativeToLegacy, this)` directly. The `translatePeerCertificate`
lazy-load and call are removed. This reverses the fix's `x509.js` hunk, re-expressed for
today's code (`internal/tls/common`, private-state class). That hunk added the translation
call. The now-unused `lazyTranslatePeerCertificate` declaration is also removed, which
reverses the fix's first `x509.js` hunk.

**Not reversed:** the C++ hunks (removal of `names_as_string` in `X509ToObject`). The code
has been rewritten since (`X509View`, dictionary template), so the old string-name
branch no longer exists and a faithful reversal would be an invention. The JS hunk
alone is enough to bring the defect back.

**Failing tests (stable across 2 runs):** `parallel/test-crypto-x509` and
`parallel/test-x509-escaping` report `not ok`. I only checked the TAP "not ok" lines, not the
exact assertion messages. The cause is that `toLegacyObject()` output no longer matches the
translated peer-certificate shape (for example `infoAccess`, and the `deepStrictEqual`
against `peerCert`).
