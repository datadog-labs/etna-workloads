# vfs: resolve symlinks when checking rename descendants

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 816790e0e55c9e243c29581ed339f04429a19808 applied to v26.13.0 (clean).

Upstream commit message:

```
vfs: resolve symlinks when checking rename descendants

Check resolved source and destination parent paths before renaming a
directory to prevent moving it into its own subtree through a symlink.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: codex
PR-URL: https://github.com/nodejs/node/pull/65904
Fixes: https://github.com/nodejs/node/issues/65903
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```
