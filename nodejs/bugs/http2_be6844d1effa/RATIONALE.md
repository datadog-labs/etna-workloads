# http2: fix no response event on continue request

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit be6844d1effa0427ca530e07b30de897b5dd7fb2 applied to v26.13.0 (clean).

Upstream commit message:

```
http2: fix no response event on continue request

When sending a continue request, server response with null,
it does not fires the response event type

Fixes: https://github.com/nodejs/node/issues/38258

PR-URL: https://github.com/nodejs/node/pull/41739
Refs: https://github.com/nodejs/node/pull/38561
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
