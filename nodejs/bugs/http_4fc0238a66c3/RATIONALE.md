# http: do not default to chunked encoding for TRACE

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 4fc0238a66c3cdc55ddea92d98a7003f34a611ac applied to v26.13.0 (clean).

Upstream commit message:

```
http: do not default to chunked encoding for TRACE

Fixes: https://github.com/nodejs/node/issues/25783

PR-URL: https://github.com/nodejs/node/pull/27673
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Yongsheng Zhang <zyszys98@gmail.com>
Reviewed-By: Rich Trott <rtrott@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
