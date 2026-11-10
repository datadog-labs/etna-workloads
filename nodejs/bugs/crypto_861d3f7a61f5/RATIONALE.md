# Re-introduced bug: unprintable X509 extension aborts the process

**Bug.** When an X509 extension (here a subjectAltName entry of an
unsupported GENERAL_NAME type, `23`) cannot be printed to a BIO,
certificate-to-object conversion hit an unrecoverable assertion instead of
degrading gracefully. As a result, `tls.TLSSocket#getPeerCertificate()`
crashed the whole process when handed such a certificate
(see HackerOne report 746733, fixed upstream by
861d3f7a61f543c253337cfc1a967fa84f96c653).

**How today's code differs from the code the fix touched.** The original
fix changed `X509ToObject()` in `src/node_crypto.cc`, which built a plain
object of extensions by iterating `X509_get_ext()` and calling
`X509V3_EXT_print()` into a shared BIO, previously `CHECK_EQ(1, ...)`-ing
the return value. That function and its iteration-based extension object no
longer exist in the current tree: extension handling has been refactored
into `deps/ncrypto` (`SafeX509SubjectAltNamePrint`,
`SafeX509InfoAccessPrint`, etc., out of scope for this task) and into
`src/crypto/crypto_x509.cc`'s `GetSubjectAltNameString()`, which is the
modern direct equivalent of the subjectAltName path exercised by the
regression test. When the underlying BIO/printer fails on a malformed or
unsupported extension but an extension is nonetheless present,
`GetSubjectAltNameString()`'s `kReturnLegacySentinel` branch (used by the
legacy TLS peer-certificate object returned from `getPeerCertificate()`)
gracefully substitutes a placeholder string (`"DNS:"`) instead of
propagating failure — this is the direct descendant of the fix's
"replace the value with something safe instead of asserting" behaviour.

**The re-introduced hunk (`src/crypto/crypto_x509.cc`,
`GetSubjectAltNameString`).** Corresponds to the fix's single implementation
hunk in `src/node_crypto.cc` (the `X509ToObject` extension loop). The fix
replaced an unconditional `CHECK_EQ(1, X509V3_EXT_print(...))` with a
graceful `Null()` + `continue` fallback. I reverted the modern equivalent of
that fallback: in the `kReturnLegacySentinel` branch, instead of returning
the legacy sentinel value, the code now does `CHECK(bio)`, which is always
false in this branch (we're already inside `if (!bio)`) and so always
aborts the process — reproducing the old unconditional assertion-on-failure
behaviour for unprintable extensions reached through
`getPeerCertificate()`.

**Build and test.** `make -j8` completed successfully. Running:

```
python3 tools/test.py -p tap -j 4 --shell out/Release/node \
  --temp-dir <scratch> \
  parallel/test-tls-cert-ext-encoding
```

fails (`not ok 1 parallel/test-tls-cert-ext-encoding`) with the process
aborting on the reintroduced assertion, run twice to confirm stability:

```
TAP version 13
1..1
not ok 1 parallel/test-tls-cert-ext-encoding
  ---
  duration_ms: 267.69600
  severity: crashed
  exitcode: -6
  stack: |-

      #  out/Release/node[2325]: v8::MaybeLocal<v8::Value> node::crypto::{anonymous}::GetSubjectAltNameString(node::Environment*, const ncrypto::X509View&, MalformedSubjectAltNameMode) at ../src/crypto/crypto_x509.cc:198
      #  Assertion failed: bio

    ----- Native stack trace -----

     1: 0x63cc2dcd276c node::DumpNativeBacktrace(_IO_FILE*) [out/Release/node]
     2: 0x63cc2de8f4b0  [out/Release/node]
     3: 0x63cc2de8f5de node::Assert(node::AssertionInfo const&) [out/Release/node]
     4: 0x63cc2e388232  [out/Release/node]
     5: 0x63cc2e38b82a  [out/Release/node]
     6: 0x63cc2e38d32b node::crypto::X509Certificate::toObject(node::Environment*, ncrypto::X509View const&) [out/Release/node]
     7: 0x63cc2e2d37df node::crypto::GetPeerCert(node::Environment*, ncrypto::SSLPointer const&, bool, bool) [out/Release/node]
     8: 0x63cc2e37dad3 node::crypto::TLSWrap::GetPeerCertificate(v8::FunctionCallbackInfo<v8::Value> const&) [out/Release/node]
     9: 0x773d4bdcfae9

    ----- JavaScript stack trace -----

    1: TLSSocket.getPeerCertificate (node:internal/tls/wrap:1268:20)
    2: <node-checkout>/test/parallel/test-tls-cert-ext-encoding.js:77:31
    3: <node-checkout>/test/common/index.js:512:15
    4: wrapper (node:events:639:12)
```

This matches the clean-release test passing and this modified tree
crashing the process exactly where the pre-fix assertion used to fire,
confirming the defect was faithfully re-introduced.
