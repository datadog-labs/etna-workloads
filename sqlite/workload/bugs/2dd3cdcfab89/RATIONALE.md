# Rationale

Fix (2014-04-26) has two implementation hunks in `whereLoopAddBtreeIndex` and `wherePathSolver`, both in src/where.c.

## Hunk 1: `WO_ISNULL` sets `WHERE_COLUMN_NULL` (src/where.c, whereLoopAddBtreeIndex)
The fix added `else if( eOp & WO_ISNULL ){ wsFlags |= WHERE_COLUMN_NULL }`. Before it, the
chain ended in `else if( (eOp & WO_ISNULL)==0 ){ ...range... }`, so IS NULL terms set no flag.
I restored that: the range branch is now guarded by `(eOp & WO_ISNULL)==0` and the
`WHERE_COLUMN_NULL` branch is gone. The only consumers today are `whereInterstageHeuristic`
and an assert, so no oracle case notices this change on its own.

## Hunk 2: sort cost +16 (src/where.c, sort cost)
The fix added `+ 16` to the sort cost, about 5x in LogEst units, because sorting was too cheap.
Today that computation lives in `whereSortingCost()`. It has been rewritten and has no such constant.
The pre-fix behaviour is a sort cost that is 16 lower than the fixed one, so I changed
`rSortCost += estLog(nRow);` to `rSortCost += estLog(nRow) - 16;`. This is an
approximation of the old cost, not a literal revert.

## Oracle failures
- `cost-1.2` and `orderby5-2.1a` fail. The planner picks a plan that sorts when it should use an index, or the reverse.
- Hunk 1 alone causes no failures.
