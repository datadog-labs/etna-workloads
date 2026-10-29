# Rationale

Fix: ticket 623eff57e76d45f6. `whereApplyPartialIndexConstraints()` was skipped for
the right table of a LEFT JOIN, because the partial-index WHERE clause need not be
true for a NULL-extended row.

In 3.54.1 the case is covered twice, so both are reverted:

1. `src/wherecode.c` (sqlite3WhereCodeOneLoopStart): the fix's `if( pLevel->iLeftJoin==0 )`
   guard around `whereApplyPartialIndexConstraints` is removed, so the call happens
   again for LEFT JOIN right tables. The `pLevel->pRJ==0` check (RIGHT JOIN, 2025) is
   left in place because it is a separate later fix. The `else` branch with its
   testcase/assert is dropped along with the guard.
2. `src/where.c` (whereUsablePartialIndex): removed the line
   `((jointype & JT_OUTER)==0 || ExprHasProperty(pExpr, EP_OuterON))`. That line stops
   a partial index from being chosen for an outer-join table when the implying WHERE
   term is not an ON term. It is the same defect: the other path that keeps the
   optimization away from the right table of a LEFT JOIN. Without it, the planner picks
   the partial index and the wherecode.c step then marks the WHERE term as coded.

Oracle: test/join.test join-20.2 fails (and join-21.10). The query
`SELECT * FROM t0 LEFT JOIN t1 WHERE NULL IN (c1)` returns a row instead of an empty
result once the partial index `t1x ... WHERE NULL IN (c1)` exists.
