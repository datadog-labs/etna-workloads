# dgram: fix abort on bad args

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit d1dd4e10db5cb163f265a1abd1f5952f60a81e09 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
dgram: fix abort on bad args

This commit fixes a C++ abort for connected dgram sockets
by improving input validation in the JS layer.

Fixes: https://github.com/nodejs/node/issues/28126
PR-URL: https://github.com/nodejs/node/pull/28135
Reviewed-By: Richard Lau <riclau@uk.ibm.com>
Reviewed-By: Yongsheng Zhang <zyszys98@gmail.com>
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
Reviewed-By: Santiago Gimeno <santiago.gimeno@gmail.com>
Reviewed-By: Rich Trott <rtrott@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
