# fs: close file streams with fd 0

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit e7d5352fa6cc52826507cf195f066587052f62f3 applied to v26.13.0 (clean).

Upstream commit message:

```
fs: close file streams with fd 0

Signed-off-by: greenhead <greenheadhq@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/66131
Fixes: https://github.com/nodejs/node/issues/57905
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```
