# Rationale

Both fix hunks still applied conceptually in 3.54.1, so both were reverted.

1. `src/alter.c` `renameResolveTrigger()`: removed the two calls
   `renameSetENames(pStep->pExprList, ENAME_SPAN)` / `(…, ENAME_NAME)` around
   `sqlite3SelectPrep()`. This reverses the alter.c hunk. The helper
   `renameSetENames` is left defined (now unused), as it is only a helper.
   Without them, UPDATE SET-expression names are resolved as column aliases
   from ON() clauses.
2. `src/select.c` `sqlite3SubqueryColumnTypes()`: restored
   `if( db->mallocFailed ) return;`, dropping `|| IN_RENAME_OBJECT`. This
   reverses the select.c hunk.

## Oracle failures
`altertab-33.1` (and the rest of that file) fails: running
`ALTER TABLE t1 RENAME COLUMN a TO b` crashes with the assertion
`pExpr->iTable==pExpr->pLeft->x.pSelect->pEList->nExpr` in sqlite3ExprAffinity,
instead of returning "error in trigger r3 after rename: no such column: a".
