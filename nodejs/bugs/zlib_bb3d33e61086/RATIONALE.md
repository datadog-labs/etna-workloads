# zlib: fix abort with decodeStrings: false

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit bb3d33e610861dd0cb917f97da6b2d3b799bb5c1 applied to v26.13.0 (clean).

Upstream commit message:

```
zlib: fix abort with decodeStrings: false

Passing decodeStrings: false to a zlib stream, or to an async
convenience method, let strings reach the native handle, which
aborts the process on its Buffer check. Force decodeStrings back to
true, as is already done for encoding and objectMode.

Signed-off-by: James Ross <james@jross.me>
PR-URL: https://github.com/nodejs/node/pull/66359
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
