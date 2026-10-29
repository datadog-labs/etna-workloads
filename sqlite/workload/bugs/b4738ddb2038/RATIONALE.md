# Rationale

Fix (a70958cd): in `sqlite3VdbeMemClearAndResize()` the assert became
`assert( CORRUPT_DB || szNew>0 )`, because on a corrupt database `szNew` can be <=0.

## Changes (tree/src/vdbemem.c)

1. `sqlite3VdbeMemClearAndResize()`: `assert( CORRUPT_DB || szNew>0 )` -> `assert( szNew>0 )`.
   Direct reversal of the fix hunk.
2. `sqlite3VdbeMemFromBtree()`: removed the later guard
   `if( amt>=SQLITE_MAX_ALLOCATION_SIZE ) return SQLITE_NOMEM_BKPT;` (and its two testcases).
   In 3.54.1 this guard rejects a huge corrupt record size before it reaches
   `sqlite3VdbeMemClearAndResize(pMem, amt+1)`, so reversing hunk 1 alone does not
   bring the bug back. Without it, the same defect (a corrupt payload size making
   `amt+1` overflow to a non-positive `int`) reaches the assert again, as in 2019.

## Oracle
`corruptL-2.2` fails (`SELECT b,c FROM t1 ORDER BY a` on the corrupt db): `IdxRowid`
reads an index cell with payload size 4172469395, `amt+1` becomes negative, and the
`assert( szNew>0 )` fires instead of returning "database disk image is malformed".
