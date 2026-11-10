# http: use null prototype for headersDistinct/trailersDistinct

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit ef5929b5aaae7a14e839e2123f54580d18702df0 applied to v26.13.0 (clean).

Upstream commit message:

```
http: use null prototype for headersDistinct/trailersDistinct

Use { __proto__: null } instead of {} when initializing the
headersDistinct and trailersDistinct destination objects.

A plain {} inherits from Object.prototype, so when a __proto__
header is received, dest["__proto__"] resolves to Object.prototype
(truthy), causing _addHeaderLineDistinct to call .push() on it,
which throws an uncaught TypeError and crashes the process.

Ref: https://hackerone.com/reports/3560402
PR-URL: https://github.com/nodejs-private/node-private/pull/821
Refs: https://hackerone.com/reports/3560402
Reviewed-By: Marco Ippolito <marcoippolito54@gmail.com>
Reviewed-By: Rafael Gonzaga <rafael.nunu@hotmail.com>
CVE-ID: CVE-2026-21710
```
