# fs: fix crash on negative zero file descriptor

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 99a78b0d83645d296c0f4bd225014fd1270f3c84 applied to v26.13.0 (clean).

Upstream commit message:

```
fs: fix crash on negative zero file descriptor

`isInt32()` accepts -0 because `-0 === (-0 | 0)`, but V8 does not
represent -0 as an Int32 value, so `Value::IsInt32()` rejects it. The
utf8 fast paths of `readFileSync()` and `writeFileSync()` hand the value
straight to the binding, which then took it for a path and aborted on
the null check.

Coerce -0 to 0 before the call, matching `getValidatedFd()` and the rest
of fs, where -0 is a valid way to name file descriptor 0.

Signed-off-by: Christian Aurich <christian.aurichzm@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65888
Fixes: https://github.com/nodejs/node/issues/65886
Reviewed-By: Xuguang Mei <meixuguang@gmail.com>
```
