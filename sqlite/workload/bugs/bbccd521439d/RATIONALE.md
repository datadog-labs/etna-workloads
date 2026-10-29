# Rationale

Fix hunk (src/where.c, termCanDriveIndex): added an early `return 0` for a
WO_IS term on the RHS of a LEFT JOIN unless the term came from the ON clause.

In 3.54.1 that check was generalized into `constraintCompatibleWithOuterJoin()`
(called from `termCanDriveIndex()`), which rejects any WHERE-clause term for an
outer-join RHS table. I reverted the IS case by adding
`&& (pTerm->eOperator & WO_IS)==0` to that call's condition in
`termCanDriveIndex()` (src/where.c), so IS terms from the WHERE clause again
skip the outer-join check and can drive an automatic index on a LEFT JOIN RHS.

Oracle: `autoindex1-1020` fails (expected 0, got 1): the IS term
`t12.y IS t11.w` from WHERE drives an automatic index on t12, so the NULL-extended
row is wrongly matched. All other oracle cases pass.
