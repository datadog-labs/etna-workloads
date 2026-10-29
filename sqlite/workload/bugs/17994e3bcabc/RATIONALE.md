# Rationale

## src/where.c, whereRangeVectorLen()
Reverses the where.c hunk of the fix: removes the `pColl==0` guard (`if( pColl==0 ) break;`)
after `sqlite3BinaryCompareCollSeq()`. When a vector comparison term uses an unknown collation
(`COLLATE nose`), that function returns NULL, and `pColl->zName` is dereferenced -> NULL pointer crash.

## src/expr.c, sqlite3FindInIndex()
Not changed. Today's code already tolerates a NULL `pReq` (`pReq!=0 && ...`), so the fix's
`if( pReq==0 ) break;` hunk is covered by different code, and reverting it would not restore a bug.

## Oracle
rowvalue4-7.4 (`SELECT * FROM f1 WHERE (?, ? COLLATE nose) > (a, b)`) crashes testfixture
(segfault) instead of returning "no such collation sequence: nose"; output ends at 7.4.
