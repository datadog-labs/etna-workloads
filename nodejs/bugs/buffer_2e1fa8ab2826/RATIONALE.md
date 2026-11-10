# buffer: fix `Blob` constructor on various `TypedArray`s

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 2e1fa8ab2826fb812be3a7c587f48d59c83f405c applied to v26.13.0 (fuzzy).

Upstream commit message:

```
buffer: fix `Blob` constructor on various `TypedArray`s

Fixes: https://github.com/nodejs/node/issues/40705
    
PR-URL: https://github.com/nodejs/node/pull/40706
Reviewed-By: Robert Nagy <ronagy@icloud.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: Minwoo Jung <nodecorelab@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
