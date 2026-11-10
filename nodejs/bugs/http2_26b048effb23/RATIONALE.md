# http2: remove square brackets from parsed hostname

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 26b048effb23eb479fe0e10087860bb7f9862f2a applied to v26.13.0 (clean).

Upstream commit message:

```
http2: remove square brackets from parsed hostname

Make `http2.connect()` work when using URLs with literal IPv6
addresses.

Fixes: https://github.com/nodejs/node/issues/28216

PR-URL: https://github.com/nodejs/node/pull/28406
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Rich Trott <rtrott@gmail.com>
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Jiawen Geng <technicalcute@gmail.com>
```
