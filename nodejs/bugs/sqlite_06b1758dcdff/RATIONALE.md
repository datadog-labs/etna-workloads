# sqlite: reject non-positive backup rates

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 06b1758dcdffaa7f6ae65ca3a5411af6e3afa095 applied to v26.13.0 (clean).

Upstream commit message:

```
sqlite: reject non-positive backup rates

Passing a rate of 0 to backup() causes sqlite3_backup_step() to copy
no pages. The backup job then continually reschedules itself and the
returned promise never settles.

Require backup rates to be positive integers to prevent zero-work
backup jobs.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: codex:gpt-5.6-sol
PR-URL: https://github.com/nodejs/node/pull/64893
Fixes: https://github.com/nodejs/node/issues/64892
Reviewed-By: James M Snell <jasnell@gmail.com>
```
