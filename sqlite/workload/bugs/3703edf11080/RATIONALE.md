# Rationale

## Change
`tree/src/select.c`, `substExpr()`: removed the `#ifndef SQLITE_OMIT_WINDOWFUNC`
block that, for expressions with `EP_WinFunc`, ran substitution over
`pWin->pFilter`, `pWin->pPartition` and `pWin->pOrderBy`.

This reverses the fix's `src/select.c` `substExpr` hunk, which added exactly that
block. Without it, column references inside FILTER clauses and window
PARTITION BY / ORDER BY are not rewritten when a subquery is flattened. They
keep pointing at the flattened-away table's cursor.

The other fix hunks are not reverted:
- The `clearSelect` assert move is assert-only.
- The `IsWindowFunc` macro change is a build fix for `SQLITE_OMIT_WINDOWFUNC`.

## Oracle failures
- `window1-31.2` (`d IN (SELECT sum(c) OVER (ORDER BY e+c) FROM t3) FROM (SELECT * FROM t2)`)
  fails with `sqlite3VdbeExec: Assertion 'pC!=0' failed`. The ORDER BY of the
  window still references the flattened subquery's cursor.
- Because the assert aborts the run, later cases in `window1.test` (31.3 and
  others) did not run, and `filter1.test` 5.1–5.3 were not reached in the
  output I looked at.
