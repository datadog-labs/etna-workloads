# Rationale

The fix (ticket 727074e2) stopped setting `omit` on the `aggregate=?` constraint in `statBestIndex` (src/dbstat.c). Without that, SQLite treats the constraint as fully handled by the vtab and does not re-check it. xFilter does not filter rows on a plain `aggregate=NULL` or `aggregate=5`, so the wrong rows come back.

Change: in `statBestIndex`, the `if( iAgg>=0 )` block again sets `pIdxInfo->aConstraintUsage[iAgg].omit = 1;`. This is exactly the line the fix commented out.

Oracle cases that fail: stat-8.2 (`aggregate = NULL` returns rows instead of none) and stat-8.3 (`SELECT aggregate=1 ... WHERE aggregate=5` returns `1 1` instead of nothing).
