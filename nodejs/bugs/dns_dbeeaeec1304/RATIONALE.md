# dns: handle large resolveAny address replies

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit dbeeaeec1304e9a0a2609bcdb0270d93921089b5 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
dns: handle large resolveAny address replies

Refs: https://hackerone.com/reports/3795657
Signed-off-by: RafaelGSS <rafael.nunu@hotmail.com>
PR-URL: https://github.com/nodejs-private/node-private/pull/929
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
CVE-ID: CVE-2026-58042
```
