# Rationale

Fix hunk reversed: in `substExpr()` the fix added
`if( pNew && pSubst->isLeftJoin ) ExprSetProperty(pNew, EP_CanBeNull);`
so that a column substituted from a flattened LEFT JOIN subquery is marked
as possibly NULL. In 3.54.1 this is `if( pSubst->isOuterJoin ){ ExprSetProperty(pNew, EP_CanBeNull); }`
in `src/select.c`. I deleted that block. The other fix hunks (EP_FromJoin
style cleanup, comment typo) are not behavioural, so I left them.

Without EP_CanBeNull, a substituted column that is NOT NULL-labelled (e.g. the
INTEGER PRIMARY KEY `x2.id`) is treated by the planner as never NULL, so
`x2.id=x3.c3` in the second LEFT JOIN is wrongly optimised.

Oracle failure: `join-14.20` fails (the only failing case, 1 of 199).
