# Rationale

Fix: flattenSubquery() (restriction 17) must refuse to flatten a UNION ALL
sub-query whose terms have different column counts (`pSub->pEList->nExpr!=pSub1->pEList->nExpr`),
so the syntax error is later reported by multiSelect().

In 3.54.1 that case is covered from another path: resolve.c (resolveSelectStep)
reports the mismatch before flattening, so flatten only has an `assert()` for it.
To restore the 2012 state:

1. `src/select.c` flattenSubquery: removed the `assert( pSub->pEList->nExpr==pSub1->pEList->nExpr )`
   in the restriction (17) loop. Equivalent to the fix's missing `||` condition: flatten neither checks nor
   rejects mismatched terms (reverses the fix's select.c hunk).
2. `src/resolve.c`: removed the early compound-SELECT column-count check (the "same defect" covered
   by another path; the later check that made the fix's hunk redundant).
3. `src/select.c` multiSelect: replaced the `assert(nExpr==nExpr)` with a runtime check that
   reports sqlite3SelectWrongNumTermsError(), as in 2012 where multiSelect detected the error. Plain
   compound SELECTs (10.3) therefore still error; only paths that bypass multiSelect (flattening,
   subquery column typing) miss it.

## Oracle failures
select6-10.4 (and following 10.5–10.8): `SELECT * FROM (SELECT i FROM t UNION ALL SELECT l, m FROM j)`
is no longer rejected; in the assert-enabled testfixture it aborts in sqlite3SubqueryColumnTypes
(`pTab->nCol==pSelect->pEList->nExpr`) instead of returning the syntax error.
