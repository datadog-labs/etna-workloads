# http2: do not crash on stream listener removal w/ destroyed session

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit e585caa2bebbd238c763af588a40879b61cf240f applied to v26.13.0 (clean).

Upstream commit message:

```
http2: do not crash on stream listener removal w/ destroyed session

Do not crash when the session is no longer available.

Fixes: https://github.com/nodejs/node/issues/29457

PR-URL: https://github.com/nodejs/node/pull/29459
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
Reviewed-By: Minwoo Jung <minwoo@nodesource.com>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
```
