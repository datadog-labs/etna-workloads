# fs: close dir before throwing if `options.bufferSize` is invalid

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 9ab976397da80e84ebf9ed12c3e7bd308aab6de1 applied to v26.13.0 (clean).

Upstream commit message:

```
fs: close dir before throwing if `options.bufferSize` is invalid

PR-URL: https://github.com/nodejs/node/pull/58856
Fixes: https://github.com/nodejs/node/issues/58854
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Juan José Arboleda <soyjuanarbol@gmail.com>
```
