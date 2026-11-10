# vfs: fix VirtualReadStream race with async iteration

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit ce54e2a9c817db9de0487a883c248420a418614c applied to v26.13.0 (clean).

Upstream commit message:

```
vfs: fix VirtualReadStream race with async iteration

Fixes: https://github.com/nodejs/node/issues/64377
Signed-off-by: y1d7ng <y1d7ng@yeah.net>
PR-URL: https://github.com/nodejs/node/pull/64394
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
