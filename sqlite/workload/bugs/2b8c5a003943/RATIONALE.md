# Rationale

Fix (ticket 32b63d542433ca67): in selectExpander(), the FROM-clause subquery
walk `sqlite3WalkSelect(pWalker, pSel)` ignored its abort result, so errors in
the subquery's FROM clause did not unwind before the "*" expander ran.

In 3.54.1 the one-line fix is still present, but two later guards also stop
analysis after an error, so reverting only the fix hunk is not enough. All
three edits are in src/select.c and undo the same defect (errors in the nested
FROM clause being ignored before "*" expansion):

1. selectExpander, subquery case: `if( sqlite3WalkSelect(pWalker, pSel) ) return WRC_Abort;`
   becomes `sqlite3WalkSelect(pWalker, pSel);`. This is the fix hunk, reversed directly.
2. sqlite3ExpandSubquery(): `return pParse->nErr ? SQLITE_ERROR : SQLITE_OK;`
   becomes `return SQLITE_OK;`. This is a later path that also aborts on a
   pending error, so it covers the case in (1).
3. selectExpander, before the "*" expansion: `if( pParse->nErr || sqlite3ProcessJoin(pParse, p) )`
   becomes `if( sqlite3ProcessJoin(pParse, p) )`. This is a second later nErr
   guard that also covers the case.

## Oracle result
test/fuzz2.test fuzz2-7.1 (`select e.*,0 from(s,(L))e;`) now fails with an
assertion: `selectExpander: Assertion pNestedFrom->nExpr==pTab->nCol failed`.
It is a crash on the "*" expander using a half-built subquery table.
fuzz2-7.2 is not reached, because the run aborts at 7.1.
