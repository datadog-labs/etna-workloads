# test_runner: mock dual-package with conditional exports

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 797ef40d23609314ba0266cd87d80f8c24dd07ff applied to v26.13.0 (clean).

Upstream commit message:

```
test_runner: mock dual-package with conditional exports

When `mock.module()` targets a package whose `exports` field maps
`import` and `require` to different files, the ESM resolver and the
CJS resolver disagree on the resolved path. Only the ESM path was
registered in `mockMap`, so `require()` of the mocked specifier
bypassed the mock and loaded the real CJS module.

Resolve the specifier through `Module._resolveFilename` from the
caller's directory in addition to the existing ESM resolution. When
the two paths differ, register the CJS path as a second key in
`mockMap` and invalidate `Module._cache[cjsPath]`, restoring it on
`restore()`. Single-resolution packages keep their existing behavior.

Fixes: https://github.com/nodejs/node/issues/58231
Signed-off-by: Maruthan G <maruthang4@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/62943
Reviewed-By: Aviv Keller <me@aviv.sh>
Reviewed-By: Moshe Atlow <moshe@atlow.co.il>
Reviewed-By: Jacob Smith <jacob@frende.me>
```
