# Rationale

## src/btree.c, freePage2()
Reverses the fix hunk that added `if( iPage<2 ) return SQLITE_CORRUPT_BKPT;` and
relaxed the assert to `CORRUPT_DB || iPage>1`. In 3.54.1 the check was merged into
`if( iPage<2 || iPage>pBt->nPage )`; I dropped the `iPage<2` term and restored
`assert( iPage>1 )`. The `iPage>pBt->nPage` check is later, unrelated code and is kept.

## Oracle failures
corruptI-8.1: DELETE FROM t1 on a db whose interior page's right-child pointer is 1
reaches freePage2(page 1): assertion `iPage>1` fails (testfixture aborts), instead of
returning SQLITE_CORRUPT. corruptI-8.2 then does not run (incomplete run).
