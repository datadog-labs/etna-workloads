# Rationale

Fix hunk (src/expr.c, sqlite3SelectDup): `if( p->pWin ) gatherSelectWindows(pNew);`
became `if( p->pWin && db->mallocFailed==0 ) ...`.

## Changes in tree/src/expr.c (sqlite3SelectDup)
1. Reverted the hunk directly: `gatherSelectWindows(pNew)` is called again even
   if an OOM already occurred (the `db->mallocFailed==0` guard is removed).
2. On its own this no longer fails, because 3.54.1 added a later generic guard
   in the same function: `if( db->mallocFailed ){ ... sqlite3SelectDelete(db,pNew); break; }`,
   which discards the incomplete Select after the OOM. That is the same defect
   (an incomplete Select with window state surviving an OOM into the code
   generator), so I removed that block too, restoring the 2019 behaviour of
   `*pp = pNew;` unconditionally.

## Oracle
windowfault.test fails: the run asserts in sqlite3SrcListAssignCursors
(`Assertion 0 failed`) starting at the windowfault-10 OOM cases (the sub-select
window-in-window-frame query added by the fix), aborting the run.
