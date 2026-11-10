# tls: load all CRLs from a PEM bundle

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 2a8b5d92696d8007b04e3f31a324eb11cfb85203 applied to v26.13.0 (clean).

Upstream commit message:

```
tls: load all CRLs from a PEM bundle

AddCRL() read a single PEM block and returned, so a crl option holding
several concatenated CRLs only ever got its first entry into the store.
Any certificate whose issuer's CRL came later in the bundle then failed
with UNABLE_TO_GET_CRL.

Read in a loop until the BIO is exhausted, the way AddCACertificates()
right above it already does for ca bundles.

Signed-off-by: Lazizbek Ergashev <lazerg2@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65577
Fixes: https://github.com/nodejs/node/issues/65576
Reviewed-By: Tim Perry <pimterry@gmail.com>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
```
