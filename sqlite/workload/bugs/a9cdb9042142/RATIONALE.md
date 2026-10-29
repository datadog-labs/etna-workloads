# Rationale

Fix: autoindex partial-index construction (and bloom filter) switched to a new
helper `sqlite3ExprIsTableConstraint()` enforcing rules (3)-(5) (LEFT JOIN
ON-clause must be the one for this table; non-LEFT tables must not use ON-clause terms).
In 3.54.1 that helper is `sqlite3ExprIsSingleTableConstraint()`.

## Changes
- `src/where.c` constructAutomaticIndex: replaced the call to
  `sqlite3ExprIsSingleTableConstraint()` with the pre-fix condition
  `(jointype&(JT_LEFT|JT_LTORJ))==0 || ExprHasProperty(pExpr,EP_OuterON)` plus
  `sqlite3ExprIsTableConstant(pExpr, pSrc->iCursor, 0)`. This is the removed
  hunk in where.c (EP_FromJoin is EP_OuterON today). It drops rules (4b)/(5)/(6).
- `src/expr.c`, `src/sqliteInt.h`: `sqlite3ExprIsTableConstant` made non-static
  and declared so where.c can call it (pre-fix code called it directly).

The bloom-filter hunk was not reverted; the autoindex path alone reproduces the bug.

## Failing oracle cases
- autoindex-1110: returns empty instead of `1 1 1 2 {} {}` (ON term of an
  unrelated LEFT JOIN wrongly becomes a partial-index filter on t2).
- autoindex-1120: returns `1 1 {} {} abc def` instead of `1 1 1 2 {} {}`.
