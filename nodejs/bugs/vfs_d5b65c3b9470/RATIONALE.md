# vfs: validate ZipProvider parent directories

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit d5b65c3b9470e4546766817fb6e268504f2e5eb1 applied to v26.13.0 (clean).

Upstream commit message:

```
vfs: validate ZipProvider parent directories

Reject attempts to create archive entries beneath non-directory
parents. Cover open, mkdir, and rename in the sync and async APIs.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: codex
PR-URL: https://github.com/nodejs/node/pull/65829
Fixes: https://github.com/nodejs/node/issues/65828
Reviewed-By: James M Snell <jasnell@gmail.com>
```
