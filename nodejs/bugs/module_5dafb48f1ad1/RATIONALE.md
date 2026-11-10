# module: fix require.resolve() crash on non-string paths

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 5dafb48f1ad10c4eec0bb10176087a59e5ef9c62 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
module: fix require.resolve() crash on non-string paths

Previously, `require.resolve()` could crash when:
- The first parameter was a relative path and
- The `paths` array contained non-string entries

This commit fixes the issue by adding a check in
`Module._findPath` to ensure all elements in `paths`
are strings, and adding a validation in `stat` before
calling `InternalModuleStat` to guard against
non-string filenames.

PR-URL: https://github.com/nodejs/node/pull/56942
Fixes: https://github.com/nodejs/node/issues/47698
Reviewed-By: Joyee Cheung <joyeec9h3@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
