# zlib: pause stream if outgoing buffer is full

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 9052ef43dc2d1b0db340591a9bc9e45a25c01d90 applied to v26.13.0 (clean).

Upstream commit message:

```
zlib: pause stream if outgoing buffer is full

Signed-off-by: Matteo Collina <hello@matteocollina.com>
PR-URL: https://github.com/nodejs-private/node-private/pull/540
Reviewed-By: Robert Nagy <ronagy@icloud.com>
Ref: https://hackerone.com/reports/2284065
CVE-ID: CVE-2024-22025
```
