# worker: do not send message if port is closing

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 44131ad638c6c5ad59e220297fd3bb802fb5b1f9 applied to v26.13.0 (clean).

Upstream commit message:

```
worker: do not send message if port is closing

Fixes: https://github.com/nodejs/node/issues/42296

PR-URL: https://github.com/nodejs/node/pull/42357
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
```
