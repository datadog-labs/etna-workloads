# Rationale

## Change
`tree/src/alter.c`, `renameResolveTrigger()`: removed `sNC.pSrcList = 0;` after the
per-step resolution (just before `sqlite3SrcListDelete(db, pSrc)`).

Reverses fix hunk 3 (`+ sNC.pSrcList = 0;`). The fix's other hunks only moved the
`SrcList sSrc` declaration into the inner block. In 3.54.1 that variable is gone
(replaced by a heap-allocated `pSrc`), so they have no equivalent. Without the reset,
`sNC.pSrcList` keeps pointing at the freed `pSrc` while the next trigger step, or the
SELECT in the same trigger, is resolved. That is the stale-reference defect the fix removed.

## Oracle
`altertab2-8.2` fails: `lookupName: Assertion 'pTab!=0 && pTab->zName!=0' failed`.
The rename resolves `SELECT a,b,c FROM v1` against the stale outer SrcList of the
preceding UPDATE step. The expected result is `error in trigger tr after rename: no such column: a`.
