# CVE-2021-44533 re-introduction (x509 subject/issuer handling)

**Bug.** Peer-certificate `subject`/`issuer` are rendered as escaped multi-line strings and decoded in JS by a naive `parseCertString` (split on `\n`, first `=`). Escapes (`\00`, `\0A`, `\+`) are never decoded and multi-value RDNs (`+`) aren't handled, so distinct DNs yield ambiguous/incorrect objects.

**Hunks.**
- `src/crypto/crypto_x509.cc` (`X509ToObject`) corresponds to the fix's `X509ToObject` change in crypto_common.cc (`names_as_string` branch / `GetX509NameObject`). It now sets subject/issuer from the string forms (`getSubject()`/`getIssuer()`) instead of building objects in C++. The now-unused `GetX509NameObject` was removed (corresponds to the fix's added function).
- `lib/internal/tls/common.js` corresponds to the `_tls_common.js` hunk (the `typeof === 'string'` guards). `parseCertString` is restored and applied unconditionally in `translatePeerCertificate`.
- The `ASN1_STRFLGS_ESC_2253` flag lives in deps/ncrypto (out of scope), so `X509Certificate.subject` text is unchanged.

**Failing test.** `parallel/test-x509-escaping` fails: peerCert.subject is `{ L: 'Somewhere\\00evil.example.com' }` where `{ L: 'Somewhere\x00evil.example.com' }` is expected (deepStrictEqual).
