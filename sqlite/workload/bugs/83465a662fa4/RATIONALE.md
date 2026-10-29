# Rationale

Fix: in wherePathSolver, the ORDER BY LIMIT early-out (`bOrderedInnerLoop`) is
not enabled when the inner loop is an IPK loop driven by an IN operator
(`(wsFlags & (WHERE_IPK|WHERE_COLUMN_IN))!=(WHERE_IPK|WHERE_COLUMN_IN)`).

## Changes (src/where.c)

1. wherePathSolver: removed the `(wsFlags&(WHERE_IPK|WHERE_COLUMN_IN))!=(WHERE_IPK|WHERE_COLUMN_IN)`
   condition, which is the fix hunk's added condition (the fix's only code change).
   Alone this no longer fails, because the same defect was also covered by
   the jump target.
2. sqlite3WhereOrderByLimitOptLabel: the early-out label is `pInner->addrBrk`
   (leave the inner loop) instead of `pInner->addrNxt` (next IN value). The
   modern label is safe for IN loops because it only skips to the next IN
   value, which hides the wrongly claimed ordering. Pre-fix, a row that did not
   fit in the sorter terminated the whole inner loop, which is wrong when the
   IPK IN loop yields rows in rowid order, not ORDER BY order.
   For non-IN loops addrNxt==addrBrk, so only IN loops change.

## Oracle failures

limit2-500, 501, 502 fail (wrong LIMIT results: loop exits early after the
first row that does not fit in the sorter). Also failing as collateral:
limit2-100.1 and limit2-120.1 (IN on an indexed column), because the broad
label change also affects non-IPK IN loops.
