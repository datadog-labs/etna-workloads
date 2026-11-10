# fs: fix glob TypeError on restricted dirs

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 5794e644b724c6c6cac02d306d87a4d6b78251e5 applied to v26.13.0 (clean).

Upstream commit message:

```
fs: fix glob TypeError on restricted dirs

When a directory cannot be read due to permission issues, the async
version of fs.glob() returns null from readdir(), while the sync
version returns an empty array. This causes a TypeError when trying
to access the 'length' property of null.

PR-URL: https://github.com/nodejs/node/pull/58674
Fixes: https://github.com/nodejs/node/issues/58670
Fixes: https://github.com/nodejs/node/issues/58276
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Ethan-Arrowood <ethan@arrowood.dev>
Reviewed-By: Juan José <soyjuanarbol@gmail.com>
```
