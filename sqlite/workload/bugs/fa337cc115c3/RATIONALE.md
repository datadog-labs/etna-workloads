# Rationale

Both changes are in `sqlite3WhereEnd()` in `src/where.c`. The fix commit did two things there, and I reverted both.

1. **Fix hunk 1** added `&& i==pWInfo->nLevel-1` to the skip-ahead-distinct condition. I removed that line. The optimization is again allowed on every loop of a DISTINCT join, not just the innermost.
2. **Fix hunk 2** deleted the `if( i<pWInfo->nLevel-1 ){ sqlite3VdbeResolveLabel(v, pWInfo->a[i+1].addrBrk); }` block after the `OP_Goto`. I restored it, so the next inner loop's break label is re-resolved to a point after the skip-ahead code. This was the earlier, incomplete fix for the same ticket (ef9318757b152e3).

Together these put back the pre-fix code. With skip-ahead enabled on outer loops, the inner loop's break label is resolved a second time.

## Oracle results

`./check.sh` reports 28 of 48 oracle cases failing in `test/distinct2.test`. The run aborts at distinct2-1000 with `sqlite3VdbeResolveLabel: Assertion p->aLabel[j]==(-1) failed`. That is the double label resolution described above. The remaining listed cases fail because the run stopped before reaching them. They did not each fail on their own.
