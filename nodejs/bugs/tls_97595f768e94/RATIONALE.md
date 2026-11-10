# tls: route callback exceptions through error handlers

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 97595f768e94d3d2da685dc0e5366016b146d2b7 applied to v26.13.0 (clean).

Upstream commit message:

```
tls: route callback exceptions through error handlers

Wrap pskCallback and ALPNCallback invocations in try-catch blocks
to route exceptions through owner.destroy() instead of letting them
become uncaught exceptions. This prevents remote attackers from
crashing TLS servers or causing resource exhaustion.

Fixes: https://hackerone.com/reports/3473882
PR-URL: https://github.com/nodejs-private/node-private/pull/782
PR-URL: https://github.com/nodejs-private/node-private/pull/790
CVE-ID: CVE-2026-21637
```
