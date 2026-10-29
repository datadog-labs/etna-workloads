# Rationale

Fix hunk (src/where.c, sqlite3WhereBegin): the omit-noop-left-join check must
include the ORDER BY columns in `tabUsed` (the fix switched from the stale
`pOrderBy` to `sWLB.pOrderBy`, so ORDER BY was actually consulted).

In 3.54.1 this logic lives in `whereOmitNoopJoin()` (src/where.c), which adds
`pWInfo->pOrderBy` to `tabUsed`. I removed that `if( pWInfo->pOrderBy ){ tabUsed |= ... }`
block, so ORDER BY columns of a LEFT JOIN table are ignored and the table is
omitted even when ORDER BY references it. This is the same defect: ORDER BY
usage not counted when deciding to omit the join.

Oracle failure: test/where.test where-18.1 (`SELECT DISTINCT a FROM t181 LEFT JOIN t182 ON a=b ORDER BY c IS NULL`)
hits `Assertion pC!=0 failed` in sqlite3VdbeExec (the omitted table's cursor is used).
