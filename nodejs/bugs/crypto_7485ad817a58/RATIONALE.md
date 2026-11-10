# Re-introduced bug: NODE_EXTRA_CA_CERTS lost when options are passed

**Bug.** NODE_EXTRA_CA_CERTS certs were only added to the shared default root store. Any
SecureContext that gets its own store through `NewRootCertStore()` (options such as `crl`,
`pfx`, `ca`, or `addCACert` on a default context) silently lost the extra certs, so connections
that needed them failed with a verification error.

**Hunks (src/crypto/crypto_context.cc).**
1. `NewRootCertStore()`: removed the block adding `GetExtraCACertificates()`. This matches the fix
   hunk that made `NewRootCertStore()` include the extra certs in every store (reversed).
2. `GetOrCreateRootCertStore()`: after building the shared store, add the extra certs there only
   (unless the user reset the store). This matches the pre-fix `UseExtraCaCerts` adding certs to
   the shared store only (reversed from the fix's removal of it). A forward declaration of
   `GetExtraCACertificates` was added for this.

**Failing test.** `parallel/test-tls-env-extra-ca-with-options` reports `not ok` (stable over two
runs): the client with `crl`/`pfx`/addCACert does not trust the server cert signed by the extra CA.
