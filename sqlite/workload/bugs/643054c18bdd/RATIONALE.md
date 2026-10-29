# Rationale

Fix (CVS 3128): in flattenSubquery(), the outer query's result-column names
were captured from each expression's span *after* substExprList() had replaced
view-column references with the subquery's expressions, so
`SELECT x FROM v15` (v15 = `SELECT a AS x ...`) reported `a` rather than `x`.
The fix moved the name capture before the substitution.

In 3.54.1 flattenSubquery() no longer copies names; result-column names are
computed by sqlite3GenerateColumnNames() from the outer expression list. For an
unaliased TK_COLUMN term it reads the column name from the expression itself
(`srcName && p->op==TK_COLUMN` branch). That function is called in
sqlite3Select() before the flattening loop, which is the modern form of the
fix's "capture names before substitution" ordering.

## Change (src/select.c, sqlite3Select)
The `if( pDest->eDest==SRT_Output ) sqlite3GenerateColumnNames(pParse, p);`
call is moved from before the flattening loop to after it (before the compound
SELECT handling). Names are therefore computed from the already-substituted
expressions, which restores the pre-fix ordering (substitute, then name).

## Oracle failures
test/view.test view-15.2 fails: `SELECT x, y FROM v15 LIMIT 1` returns
`a 2 b 3` instead of `x 2 y 3`.
