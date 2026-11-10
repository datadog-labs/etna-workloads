# fs: fix `getDirent().parentPath` when type is `UV_DIRENT_UNKNOWN`

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit c91ce2120c5c292f28685b364f2e3a897da751ea applied to v26.13.0 (clean).

Upstream commit message:

```
fs: fix `getDirent().parentPath` when type is `UV_DIRENT_UNKNOWN`

PR-URL: https://github.com/nodejs/node/pull/55553
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```
