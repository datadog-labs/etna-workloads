# vfs: reject statfs for missing paths

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit cf5d4a8fe625183ac103f0928921528528c15c69 applied to v26.13.0 (clean).

Upstream commit message:

```
vfs: reject statfs for missing paths

Validate mounted VFS paths before returning synthetic statfs data
so fs.statfsSync() and fs.promises.statfs() report ENOENT for missing
paths. Forward validation errors asynchronously to fs.statfs()
callbacks.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: codex:gpt-5.6-sol
PR-URL: https://github.com/nodejs/node/pull/65693
Fixes: https://github.com/nodejs/node/issues/65692
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
