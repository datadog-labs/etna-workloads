# buffer: treat detached ArrayBuffers as empty

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit bc6b630e21c1b174d492d0722bd22b50ad735e9a applied to v26.13.0 (clean).

Upstream commit message:

```
buffer: treat detached ArrayBuffers as empty

Treat detached ArrayBuffers and Buffer or TypedArray views backed by
them as zero-length inputs in buffer.isUtf8() and buffer.isAscii(). Both
functions now return true for these inputs, consistent with other empty
inputs.

Signed-off-by: Archkon <180910180+Archkon@users.noreply.github.com>
PR-URL: https://github.com/nodejs/node/pull/64504
Fixes: https://github.com/nodejs/node/issues/64503
Reviewed-By: James M Snell <jasnell@gmail.com>
```
