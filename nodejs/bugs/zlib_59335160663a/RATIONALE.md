# zlib: reject trailing gzip members in web streams

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 59335160663a88982143419080a035c15d162895 applied to v26.13.0 (clean).

Upstream commit message:

```
zlib: reject trailing gzip members in web streams

Pass the existing rejectGarbageAfterEnd option through to the native
zlib context and skip gunzip's concatenated-member loop when it is set.
This lets DecompressionStream reject a second gzip member as trailing
input while preserving default zlib gunzip behavior.

Also make the sync zlib path honor rejectGarbageAfterEnd when native
decompression leaves unused input, covering Brotli as well.

Fixes: https://github.com/nodejs/node/issues/58247

Signed-off-by: Filip Skokan <panva.ip@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/64023
Fixes: https://github.com/nodejs/node/issues/58247
Reviewed-By: Anna Henningsen <anna@addaleax.net>
```
