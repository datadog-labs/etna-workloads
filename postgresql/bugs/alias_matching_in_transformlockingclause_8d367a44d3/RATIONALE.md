# Rationale

File: src/backend/parser/analyze.c, function transformLockingClause().
Traces to the single fix.patch hunk: removes the check that skips alias-less
join RTEs (and alias-less subquery/values RTEs, later extensions of the same
check) and the join_using_alias handling. Matching is again a plain
`strcmp(rte->eref->aliasname, relname)`, so an unaliased join RTE (eref "unnamed_join")
or subquery ("subquery") can hide/match a base relation with the same name in FOR UPDATE/SHARE OF.

Failing oracle case: src/test/regress||join
