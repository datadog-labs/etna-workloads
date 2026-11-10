# zlib: preserve brotli params and dictionary on reset

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 6c927c0009a40c59e1ae9adf7429d109020434c4 applied to v26.13.0 (clean).

Upstream commit message:

```
zlib: preserve brotli params and dictionary on reset

ResetStream currently calls Init() with no arguments, which drops
the stored dictionary and never replays SetParams. Remember each
successful parameter and replay both the dictionary and the params
when the stream is reset.

Fixes: https://github.com/nodejs/node/issues/66156
Signed-off-by: Xia Chao <shapirolutts@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/66157
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
```
