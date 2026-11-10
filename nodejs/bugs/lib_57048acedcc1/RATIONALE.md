# lib: fix incorrect use of console intrinsic

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 57048acedcc18b3736140695f999b0563a779c1b applied to v26.13.0 (clean).

Upstream commit message:

```
lib: fix incorrect use of console intrinsic

The console object was not being frozen because the intrinsic
freezing code was accessing undefined instead of the console
object.

PR-URL: https://github.com/nodejs/node/pull/46044
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
Reviewed-By: Tobias Nießen <tniessen@tnie.de>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: Darshan Sen <raisinten@gmail.com>
Reviewed-By: Juan José Arboleda <soyjuanarbol@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
