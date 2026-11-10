# buffer: fix odd UTF-16LE indexOf start

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit f7d3d11c11935de949b3bfe8300c3acffd5788a9 applied to v26.13.0 (clean).

Upstream commit message:

```
buffer: fix odd UTF-16LE indexOf start

UTF-16LE string searches rounded odd forward start offsets down,
allowing a match before the requested range.

Round the start up to the next code-unit boundary while leaving
reverse search and the existing 16-bit implementation unchanged.

Assisted-by: Codex
Signed-off-by: inoway46 <inoueyuya416@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65960
Fixes: https://github.com/nodejs/node/issues/26448
Reviewed-By: Robert Nagy <ronagy@icloud.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
