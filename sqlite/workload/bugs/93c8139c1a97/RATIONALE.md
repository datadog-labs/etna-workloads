# Rationale

Fix: `resolveFromTermToCte()` returned 0 early when `pParse->nErr` was set, so a
nested CTE with errors could not leave `pParse->pWith` in a bad state.

## Changes (src/select.c)
1. `resolveFromTermToCte()`: removed the `if( pParse->nErr ) return 0;` guard.
   This is the fix hunk, reversed directly.
2. `sqlite3WithPush()`: removed the later `if( pParse->nErr==0 )` guard around
   linking the WITH into `pParse->pWith`. This is a second path covering the
   same defect (it keeps an errored WITH stack from being extended). With only
   change 1 reverted, no oracle case failed.

## Oracle
`with2-11.1` fails: testfixture hits
`Assertion 'pParse->pWith!=pWith' failed` in `sqlite3WithPush`. This is the
forum-post scenario (nested CTEs in a recursive view). Later 11.x cases are not
reached because the assert aborts the run.
