# fs: fix fs.rm support for loop symlinks

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 6f9175deaabf50558fb8637eb7c4d838da51d1d4 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
fs: fix fs.rm support for loop symlinks

Fixes: https://github.com/nodejs/node/issues/45404
PR-URL: https://github.com/nodejs/node/pull/45439
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: LiviaMedeiros <livia@cirno.name>
Reviewed-By: Minwoo Jung <nodecorelab@gmail.com>
```
