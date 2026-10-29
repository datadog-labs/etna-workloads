# Rationale

## Hunk changed: src/where.c, whereLoopAddAll()
Reverses the fix's only implementation hunk. The fix added `JT_LTORJ` to the
jointype mask that adds `mPrereq |= mPrior` (preventing reordering of FROM terms
on the left of a RIGHT/FULL JOIN). In 3.54.1 the condition had the same shape,
so I restored the pre-fix condition `(JT_OUTER|JT_CROSS)` without `JT_LTORJ`.
The surrounding comment and `hasRightCrossJoin` code are newer additions and were left alone.

## Oracle failures
join8-25010 and join8-25020 (the fix's tests) fail: the query
`t1 LEFT JOIN t2 ON true JOIN t3 ON (b2 IN (a1)) FULL JOIN t4 ON true` returns
no rows instead of `- - - - - x` / `1`, because terms left of the FULL JOIN are reordered.
