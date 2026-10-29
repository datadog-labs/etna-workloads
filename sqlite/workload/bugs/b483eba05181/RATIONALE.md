# Rationale

Bug: backing up a zero-byte source truncated the destination to zero bytes
(zeroing the schema cookie / change counter), instead of leaving one page.

Changes (all in `tree/src/backup.c`, `sqlite3_backup_step()`):

1. Removed the `if( nSrcPage==0 ){ sqlite3BtreeNewDb(p->pDest); nSrcPage = 1; }`
   block and the `rc==SQLITE_OK || rc==SQLITE_DONE` guard, restoring the
   unconditional `rc = sqlite3BtreeUpdateMeta(p->pDest,1,p->iDestSchema+1);`
   (reverses fix hunk 1). `sqlite3BtreeNewDb` itself is left in btree.c, unused.
2. Removed `assert( nDestTruncate>0 )` (fix hunk 2), which would otherwise
   fire since nDestTruncate is again 0 for an empty source.

The third hunk (the `nDestTruncate==0 ||` clause in the assert) is already
present in the tree, so it was left alone.

## Oracle failures
`pager1-9.4.1` and `pager1-9.4.2` fail (zero-byte source backup: destination
file size is 0 instead of 1024). The backup4 tests are not in check.sh's
output of failures, only these two failed in the run.
