# Rationale

Both changes are in `tree/src/where.c`.

1. `whereRangeAdjust()` reverses fix hunk 1. A TERM_VNULL ("IS NOT NULL")
   bound again reduces the estimated row count by 10 (LogEst of 2). The fix
   removed that reduction, so an IS NOT NULL term no longer reduces the
   estimate at all. The code is otherwise unchanged from the pre-fix form.
2. `whereLoopAddBtree()` reverses fix hunk 3. I removed the per-index
   `rSize = pProbe->aiRowLogEst[0];` line. `rSize` then stays at
   `pTab->nRowLogEst`, so scans of partial indexes are costed with the whole
   table's row count. The fix re-read it for each probe.

I did not touch fix hunk 2, which only adds an assert and blank lines.

## Oracle results
`./check.sh` reports index6-11.1 and index6-11.2 failing. The planner picks
`SCAN t11` where the tests expect `USING INDEX t11x`, the partial index. This
is the partial-index row-count bug the fix addresses. The test files cost.test
and index6.test were run, and no other cases failed.
