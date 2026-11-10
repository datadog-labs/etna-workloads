# tty: validate file descriptor to avoid int32 overflow

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 134fb5a8d0fd36b7675939877bad65b43cfc5ad4 applied to v26.13.0 (clean).

Upstream commit message:

```
tty: validate file descriptor to avoid int32 overflow

Fixes: https://github.com/nodejs/node/issues/37805

PR-URL: https://github.com/nodejs/node/pull/37809
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Darshan Sen <raisinten@gmail.com>
```
