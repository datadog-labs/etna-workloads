# vfs: follow symlinked dirs in recursive mkdir

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 54e8d3a14b07f6b0716859541928309600ac8b57 applied to v26.13.0 (clean).

Upstream commit message:

```
vfs: follow symlinked dirs in recursive mkdir

Recursive mkdir currently checks an existing intermediate entry
directly, so a symlink to a directory is treated as a non-directory
and throws ENOTDIR.

Resolve symlinked intermediate components while walking the recursive
mkdir path, creating new directories in the resolved target while
preserving the caller-facing first-created return path.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: openai:gpt-5.5
PR-URL: https://github.com/nodejs/node/pull/64287
Fixes: https://github.com/nodejs/node/issues/64286
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
