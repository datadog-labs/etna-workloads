# Rationale
All changes are in `ext/fts5/fts5_aux.c`. They restore the pre-fix use of `iRangeEnd==0` to mean "no range", which is the defect the fix removed.

- Fix hunks 1 and 4 (`iRangeEnd>=0` back to `iRangeEnd>0` in `fts5HighlightCb`): the range check at the top of the callback is back to `>0`. The `iPos==iRangeEnd` block is guarded again with `p->iRangeEnd>0 &&`. Version 3.54.1 had restructured that block, but the guard is the same.
- Fix hunks 3 and 5: the `ctx.iRangeEnd = -1` initializations are removed from `fts5HighlightFunction` and `fts5SnippetFunction`. The context is zeroed by `memset`, so `iRangeEnd` is 0 again.
- Fix hunk 2 (`iRangeEnd>=0 && iter.iStart<iRangeStart`): this code no longer exists in 3.54.1, so nothing was changed for it.

Result: a 1-token snippet whose range ends at token 0 is treated as having no range.

Oracle failures: `fts5af-6.3`, which runs twice. `snippet(t1,1,'[',']','...',1)` returns `...` instead of `D...`.
