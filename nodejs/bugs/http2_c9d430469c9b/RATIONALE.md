# http2: check if stream is not destroyed before sending trailers

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit c9d430469c9b1ff0295083ce9509382f46893658 applied to v26.13.0 (clean).

Upstream commit message:

```
http2: check if stream is not destroyed before sending trailers

Fixes: https://github.com/nodejs/node/issues/22855
PR-URL: https://github.com/nodejs/node/pull/22896
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
