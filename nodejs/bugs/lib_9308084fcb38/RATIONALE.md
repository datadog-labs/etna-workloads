# lib,test: redact proxy credentials in tunnel errors

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 9308084fcb388194dd35b525ce8b139206b56df7 applied to v26.13.0 (clean).

Upstream commit message:

```
lib,test: redact proxy credentials in tunnel errors

Refs: https://hackerone.com/reports/3720313
Signed-off-by: Matteo Collina <hello@matteocollina.com>
PR-URL: https://github.com/nodejs-private/node-private/pull/867
Reviewed-By: Joyee Cheung <joyeec9h3@gmail.com>
CVE-ID: CVE-2026-48615
```
