# tls: reject non-canonical IP addresses

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit ad788ccd076b30e4e547910ace0beda2d063ad10 applied to v26.13.0 (clean).

Upstream commit message:

```
tls: reject non-canonical IP addresses

TLS identity checks normalized non-canonical numeric hosts before
matching certificates. Platform resolvers can interpret the original
host as a different address.

Reject hosts that become IP addresses only after domainToASCII()
normalization.

Assisted-by: Pi
Signed-off-by: Matteo Collina <hello@matteocollina.com>
PR-URL: https://github.com/nodejs-private/node-private/pull/982
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
CVE-ID: CVE-2026-106069
CVE-ID: CVE-2026-106072
```
