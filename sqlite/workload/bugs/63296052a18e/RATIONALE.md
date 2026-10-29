# Rationale

Fix hunk (src/select.c, selectColumnsFromExprList): `nCol = pEList->nExpr` -> `nCol = pEList ? pEList->nExpr : 0`,
guarding against a NULL expression list (e.g. `SELECT 1 FROM (SELECT *)`, where expanding `*` with no tables fails and leaves pEList NULL).

In 3.54.1 this function is `sqlite3ColumnsFromExprList` in src/select.c. It had an `if( pEList ){...}else{nCol=0; aCol=0;}`
guard. I removed the guard, restoring the unconditional `nCol = pEList->nExpr; aCol = sqlite3DbMallocZero(...)`
(the pre-fix dereference of a possibly-NULL pEList). The rest of the function is unchanged.

Oracle: select1-16.1 (`SELECT 1 FROM (SELECT *)`) crashes (NULL dereference) instead of returning
`1 {no tables specified}`; the test run terminates at that case.
