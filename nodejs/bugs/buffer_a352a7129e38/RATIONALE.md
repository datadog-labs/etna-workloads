# buffer: improve ERR_BUFFER_OUT_OF_BOUNDS default

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit a352a7129e380c518d9676c55389adae10e9017d applied to v26.13.0 (fuzzy).

Upstream commit message:

```
buffer: improve ERR_BUFFER_OUT_OF_BOUNDS default

This commit changes the default message used by
ERR_BUFFER_OUT_OF_BOUNDS. Previously, the default
message implied that the problematic was always a
write, which is not accurate.

PR-URL: https://github.com/nodejs/node/pull/29098
Fixes: https://github.com/nodejs/node/issues/29097
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Sam Roberts <vieuxtech@gmail.com>
Reviewed-By: Jiawen Geng <technicalcute@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Yongsheng Zhang <zyszys98@gmail.com>
Reviewed-By: Rich Trott <rtrott@gmail.com>
```
