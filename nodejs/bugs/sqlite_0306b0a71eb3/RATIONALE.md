# sqlite: bind undefined to NULL

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 0306b0a71eb3b4ddcfa3abdfaf6963fc7bf15b83 applied to v26.13.0 (clean).

Upstream commit message:

```
sqlite: bind undefined to NULL

Omitting a named parameter binds NULL, but passing `undefined` for that
same parameter threw ERR_INVALID_ARG_TYPE. Bind `undefined` to NULL so
the two forms agree. This matches the conversion already applied to a
user-defined function's `undefined` return value, as well as SQLite's
own WASM oo1 API.

Fixes: https://github.com/nodejs/node/issues/61824
Refs: https://github.com/nodejs/node/pull/61472
Refs: https://github.com/nodejs/node/pull/62008
Co-authored-by: mike-git374 <217764531+mike-git374@users.noreply.github.com>
Assisted-by: claude:opus-5
Signed-off-by: Trevor Burnham <trevorburnham@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65709
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
```
