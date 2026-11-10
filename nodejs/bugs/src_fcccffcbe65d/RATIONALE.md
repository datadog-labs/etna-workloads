# src: fix crash when reading length on Storage.prototype

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit fcccffcbe65d05529f9a95f8784d28d6a76442cd applied to v26.13.0 (clean).

Upstream commit message:

```
src: fix crash when reading length on Storage.prototype

Signed-off-by: Mohamed Sayed <k@3zrv.com>
PR-URL: https://github.com/nodejs/node/pull/63529
Fixes: https://github.com/nodejs/node/issues/63514
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```
