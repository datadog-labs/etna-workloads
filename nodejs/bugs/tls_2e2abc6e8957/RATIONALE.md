# tls: wrap SNICallback invocation in try/catch

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 2e2abc6e895745cc5d04dd203afb8e0083fb6835 applied to v26.13.0 (clean).

Upstream commit message:

```
tls: wrap SNICallback invocation in try/catch

Wrap the owner._SNICallback() invocation in loadSNI() with try/catch
to route exceptions through owner.destroy() instead of letting them
become uncaught exceptions. This completes the fix from CVE-2026-21637
which added try/catch protection to callALPNCallback,
onPskServerCallback, and onPskClientCallback but missed loadSNI().

Without this fix, a remote unauthenticated attacker can crash any
Node.js TLS server whose SNICallback may throw on unexpected input
by sending a single TLS ClientHello with a crafted server_name value.

Fixes: https://hackerone.com/reports/3556769
Refs: https://hackerone.com/reports/3473882
CVE-ID: CVE-2026-21637

PR-URL: https://github.com/nodejs-private/node-private/pull/819
Reviewed-By: Robert Nagy <ronagy@icloud.com>
Reviewed-By: Rafael Gonzaga <rafael.nunu@hotmail.com>
CVE-ID: CVE-2026-21637
```
