# Rationale

## Changed hunk
`tree/src/select.c`, `substExpr()`: the condition guarding insertion of the
TK_IF_NULL_ROW wrapper when flattening the RHS of a LEFT JOIN.

Fix hunk reversed: the fix changed `if( pSubst->isOuterJoin && pCopy->op!=TK_COLUMN )`
to `if( pSubst->isOuterJoin )`. In 3.54.1 the code had been refined to
`pSubst->isOuterJoin && (pCopy->op!=TK_COLUMN || pCopy->iTable!=pSubst->iNewTable)`
(wrap unless the column is from the new table itself). I restored the pre-fix
`pCopy->op!=TK_COLUMN`, so any TK_COLUMN is again left unwrapped, even one that
belongs to an outer query and still needs to be NULLed out.

## Failing oracle cases
join2-10.2 and join2-10.4 return 1 instead of NULL (the outer-query column
`x` is not NULLed for the LEFT JOIN's null row).
