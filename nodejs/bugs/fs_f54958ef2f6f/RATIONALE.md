# fs: fix fsPromises.lchmod error on non-Mac

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit f54958ef2f6f66213f300f4fd2322e8d8c802e28 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
fs: fix fsPromises.lchmod error on non-Mac

On non-macOS, fsPromises.lchmod throws AssertionError.
Expected behavior is `Error [ERR_METHOD_NOT_IMPLEMENTED]`.
`ERR_METHOD_NOT_IMPLEMENTED()` requires argument, but it wasn't set.

Fixes `ERR_METHOD_NOT_IMPLEMENTED()` to
`ERR_METHOD_NOT_IMPLEMENTED('lchmod()')`.

PR-URL: https://github.com/nodejs/node/pull/21435
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Weijia Wang <starkwang@126.com>
Reviewed-By: Сковорода Никита Андреевич <chalkerx@gmail.com>
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
Reviewed-By: Yuta Hiroto <hello@hiroppy.me>
```
