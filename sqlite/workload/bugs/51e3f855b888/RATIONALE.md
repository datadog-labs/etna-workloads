# Rationale

## Change (src/select.c, sqlite3ProcessJoin)
The fix added, after building the coalesce() for a USING/NATURAL join column,
`pE1->affExpr = sqlite3ExprAffinity(pFuncArgs->a[0].pExpr);`. In 3.54.1 that
line had been refined to `pE1->affExpr = SQLITE_AFF_DEFER;`. I removed that
`if( pE1 ){ ... }` block, restoring the pre-fix behaviour: the synthesized
coalesce() carries no affinity, so comparisons against it ignore the column
affinity of the LHS (INT vs BLOB/'0' text).

## Oracle failures
joinH-14.1.2 and joinH-14.1.3 (the fix's new cases: NATURAL JOIN on the LHS of a
FULL JOIN gives the wrong result). joinH-15.1 and joinH-15.2 (later tests of the
same affinity mechanism) also fail.
