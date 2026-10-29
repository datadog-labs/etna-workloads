# Rationale

Fix hunk reversed: in `sqlite3WhereCodeOneLoopStart` (OR-clause / MULTI-INDEX OR code), the loop that
builds `pAndExpr` from the other WHERE terms had `if( ExprHasProperty(pExpr, EP_FromJoin) ) continue;`
removed by the fix. In 3.54.1 the flag is named `EP_OuterON`; I re-added
`if( ExprHasProperty(pExpr, EP_OuterON) ) continue;` in `src/wherecode.c` in that loop.
Consequence: ON-clause terms of a LEFT JOIN (e.g. `t2.x=t1.x`) are not ANDed into each OR-branch
subplan, so the branches cannot use the (x, y) index with `x=?` as well.

Other fix hunks (asserts, the pAndExpr condition, the iLeftJoin check) are either asserts or
already differ in 3.54.1 and were not needed to restore the bug.

Oracle failure: join5-7.2 (EXPLAIN QUERY PLAN of the LEFT JOIN with `t2.x=t1.x AND (t2.y=? OR ...)`
no longer shows `x=? AND y=?` index usage for both OR branches).
