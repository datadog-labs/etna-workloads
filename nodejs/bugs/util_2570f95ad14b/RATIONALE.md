# util: do not crash on inspecting function with `Symbol` name

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 2570f95ad14b91e0095a12d418580e6852345389 applied to v26.13.0 (clean).

Upstream commit message:

```
util: do not crash on inspecting function with `Symbol` name

Refs: https://github.com/nodejs/node/issues/56570
PR-URL: https://github.com/nodejs/node/pull/56572
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
```
