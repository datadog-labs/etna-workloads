# vfs: fix rename over non-empty directory

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit ea6f70ba412dfc5a6fc5d3a62bda6cdde31b19c1 applied to v26.13.0 (clean).

Upstream commit message:

```
vfs: fix rename over non-empty directory

The memory provider only rejected renames whose destination had a
different type than the source, so renaming a directory onto another
directory silently dropped the destination and everything under it.
An existing destination directory has to be empty; rename(2) reports
ENOTEMPTY otherwise, and RealFSProvider already does so because it
delegates to fs.renameSync().

Also, decrement nlink on a file that is replaced by a rename, and make
a rename whose two names resolve to the same entry a no-op, which
covers renaming one hard link onto another.

Signed-off-by: Christian Aurich <christian.aurichzm@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65613
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
