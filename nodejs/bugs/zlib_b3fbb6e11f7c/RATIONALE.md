# zlib: throw on out-of-bounds write buffers

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit b3fbb6e11f7ceb32dd87da7e954129f72090fa5c applied to v26.13.0 (clean).

Upstream commit message:

```
zlib: throw on out-of-bounds write buffers

Signed-off-by: RafaelGSS <rafael.nunu@hotmail.com>
PR-URL: https://github.com/nodejs-private/node-private/pull/931
Refs: https://hackerone.com/reports/3857258
CVE-ID: CVE-2026-58045
```
