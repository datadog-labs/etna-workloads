# Rationale

Fix: window-function rewrite left a dangling Table reference in the parse tree.

## Changes
1. `src/window.c` (sqlite3WindowRewrite): reverses the fix hunk that replaced
   `sqlite3DbFree(db, pTab)` with `sqlite3ParserAddCleanup(...)`. The temp table
   is freed immediately again, although the result-set/ORDER BY of the SELECT may
   still reference it on error (use-after-free).
2. `src/where.c` (sqlite3WhereBegin): reverses the hunk adding
   `if( pParse->nErr ) goto whereBeginError;` at the top of the per-table loop.
   This is the second line of defence against an invalid parse tree; without it,
   code generation proceeds with the bad tree.

The `sqlite3TableColumnAffinity` hunk was not reverted (already-present
`NEVER()` guard is a hardening, not needed to restore the bug).

## Oracle
Reverting only (1) was not enough (0 failures). With (1) and (2), test
window1-71.0 (the added test) aborts:
`sqlite3TableColumnAffinity: Assertion '0' failed`, from the stale table reference.
