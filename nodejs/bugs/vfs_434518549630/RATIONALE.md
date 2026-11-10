# vfs: make lchown update symlink metadata

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 434518549630f5641233b8b3291516a16450afce applied to v26.13.0 (clean).

Upstream commit message:

```
vfs: make lchown update symlink metadata

Route mounted lchown operations through VFS lchown handling and add
memory provider support that does not follow the final symlink.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: openai:gpt-5.5
PR-URL: https://github.com/nodejs/node/pull/64573
Fixes: https://github.com/nodejs/node/issues/64572
Reviewed-By: Aviv Keller <me@aviv.sh>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
