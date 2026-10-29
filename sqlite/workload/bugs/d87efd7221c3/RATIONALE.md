# Rationale

All changes are in `sqlite3PagerMovepage()` in `tree/src/pager.c`. They reverse the four hunks of the fix.

1. `if( pPager->tempFile ){ sqlite3PagerWrite(pPg) }` is back to `if( MEMDB ){` (fix hunk 1). A temp-file database that is not purely in memory no longer journals the page it is moving from.
2. The NEED_SYNC test is back to `(pPg->flags&PGHDR_NEED_SYNC) && !isCommit && pPager->tempFile==0` (fix hunk 2). The fix had commented out the `tempFile==0` term, so reinstating it restores the old code.
3. `if( pPager->tempFile ){ sqlite3PcacheMove(pPgOld, dbSize+1) } else Drop` is back to `if( MEMDB )` (fix hunk 3). For a temp-file database the old page is dropped instead of kept for rollback.
4. `if( pPager->tempFile && pPgOld )` is back to `if( MEMDB && pPgOld )` (fix hunk 4). The original page is not restored for rollback. The 3.54.1 code has the extra `&& pPgOld` check, which I kept.

## Oracle failure
`temptable2-7.1` fails. This is the auto-vacuum case on a temp database (`sqlite3 db ""`) that runs `incremental_vacuum` and then `ROLLBACK`. The test's final `PRAGMA integrity_check` no longer returns `ok`. This is the bug the fix's test guards against. The other 256 cases still pass.
