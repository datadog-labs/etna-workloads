# vfs: handle current-position sentinel in memory files

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 0b6af910819098ae79a95d66ff2dccc2bdbe0515 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
vfs: handle current-position sentinel in memory files

Treat -1 as the current file position in MemoryFileHandle read and
write operations. This matches the value passed by fs.readSync() after
normalizing a null position.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: openai:gpt-5.5
PR-URL: https://github.com/nodejs/node/pull/64163
Fixes: https://github.com/nodejs/node/issues/64162
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
