# Rationale

Fix: drh 2025-09-27, "Rework the bounds calculations on generate_series()". It added an
overflow-safe `seriesSteps()` and, in the OFFSET handling, a check that the offset does not
exceed the number of steps in the series (otherwise no rows). Before the fix, OFFSET was
applied unconditionally (`iBase += iStep*iOffset`), so a large offset wrapped or moved iBase
past iTerm.

## Change (ext/misc/series.c, seriesFilter, "Apply LIMIT and OFFSET")
Removed the `if( seriesSteps(pCur) < (sqlite3_uint64)iOffset ){ goto series_no_rows; }` branch,
reversing the fix hunk that added `if( seriesSteps(&pCur->ss) < iOffset ){ returnNoRows=1; ...}`.
The offset is again applied unconditionally. In 3.54.1 the helper and the structure differ
(`goto series_no_rows` rather than `returnNoRows`), but the check is the same.
The other hunks (iStep>SMALLEST_INT64 guard, LIMIT rewrite) are already restructured in
3.54.1 and were left alone.

## Failing oracle cases
- tabfunc01-932 (OFFSET 2 on a 2-row series): returns `9223372036854775807 -1` instead of empty.
- tabfunc01-933 (OFFSET 9223372036854775807): returns `-1` instead of empty.
- tabfunc01-943: assertion `pCur->iBase <= pCur->iTerm` in seriesSteps fails (offset past end of
  generate_series(1,11,2)); the run aborts there, so later cases did not run.
