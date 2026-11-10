# stream: fix pipeline calling end on destination more than once

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 9a50c6d93d731705fa9968e2427ca15511e0a87f applied to v26.13.0 (clean).

Upstream commit message:

```
stream: fix pipeline calling end on destination more than once

Fixes: https://github.com/nodejs/node/issues/42866
PR-URL: https://github.com/nodejs/node/pull/46226
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Robert Nagy <ronagy@icloud.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Minwoo Jung <nodecorelab@gmail.com>
```
