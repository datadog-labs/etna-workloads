# Re-introduced bug: infinite loop in GetLastIssuedCert for self-signed certs without keyCertSign

**Bug:** For a self-signed certificate whose keyUsage lacks keyCertSign, `X509_check_issued()` returns false,
so `isIssuedBy(self)` is false, and the issuer lookup returns the same certificate. The loop in
`GetLastIssuedCert` (src/crypto/crypto_common.cc) then never terminates (hang/crash).

**Hunk:** Removed the `if (cert->get() == ca.get()) break;` guard (and its comment) before
`*cert = std::move(ca);`. This corresponds to the fix's added `value_before_reset == ca` check
(re-expressed for the current code, where the pointer comparison happens before the move).

**Failing test:** `parallel/test-https-selfsigned-no-keycertsign-no-crash` -> `not ok` (timeout, the server-side
peer certificate handling loops forever). Stable across two runs.
