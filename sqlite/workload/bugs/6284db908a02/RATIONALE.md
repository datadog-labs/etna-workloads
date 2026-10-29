# Rationale

## src/select.c, sqlite3KeyInfoFromExprList
Reverses the fix's keyInfoFromExprList hunk: the loop again starts at `pList->a`
(not `pList->a+iStart`) and stores into `aColl[i]`/`aSortFlags[i]` instead of
`[i-iStart]`. With iStart>0 (block-sort, partial ORDER BY satisfied by an index)
the wrong terms' collations/sort orders are used and entries are written at the
wrong offsets. No oracle case exercises it (it is the "block sorting with
collating functions" part of the fix).

## src/where.c, whereSortingCost
Reverses the planner-weights hunk. The pre-fix cost was `20 + N + log(N)*(X-Y)/X`
(roughly 4*N*log N, partial-sort scale applied to the log term only); the fix
made it N*log N with a LogEst scale and a DISTINCT surcharge. The current
function already holds the fixed form (scale of `-66`), so I removed that scale
and restored the old linear scaling of estLog plus a constant surcharge
(30, tuned; 20 was too small to flip any plan in today's cost model, which
already has its own nCol factor). Sorting is over-priced, so the planner prefers
index lookups over a B-TREE sort.

## Oracle failures
orderby5-2.1b: expects `/B-TREE/` (sort is cheaper for a very selective
likelihood on 1,000,000-row t1), but gets `SCAN t1 USING INDEX t1bc`.
