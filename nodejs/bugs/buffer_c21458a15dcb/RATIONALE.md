# buffer: expose underlying buffer object always

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit c21458a15dcbff405b18a680e9ed18863567736b applied to v26.13.0 (fuzzy).

Upstream commit message:

```
buffer: expose underlying buffer object always

If the Buffer object's length is zero, or equal to the underlying
buffer object's length, `parent` property returns `undefined`.

    > new Buffer(0).parent
    undefined
    > new Buffer(Buffer.poolSize).parent
    undefined

This patch makes the buffer objects to consistently expose the buffer
object via the `parent` property, always.

Fixes: https://github.com/nodejs/node/issues/8266
PR-URL: https://github.com/nodejs/node/pull/8311
Reviewed-By: Trevor Norris <trev.norris@gmail.com>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
