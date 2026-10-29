# Rationale

## src/where.c, whereLoopAddBtree()
The fix guards `pNew->u.btree.pOrderBy = pSrc->u4.pSubq->pSelect->pOrderBy;` with a
check on `SF_Recursive`, so that a recursive CTE's ORDER BY (which only orders the
queue) is not treated as the order rows are emitted in. In 3.54.1 the guard was
written as `(selFlags & SF_Recursive)==0`. I removed the guard and its comment, restoring
the pre-fix unconditional assignment. The planner then again believes a recursive CTE
delivers rows in ORDER BY order and can skip the sort of the outer query.

## Oracle failure
with5-310 fails: expected `1 2 3`, got `1 3 2` (outer `ORDER BY ii` omitted because the
CTE's `ORDER BY id` is assumed to define output order). All other cases pass.
