# Rationale

## Hunk changed
`tree/src/select.c`, in `sqlite3Select()`: removed the `p->pWin==0` condition
(wrapped in `#ifndef SQLITE_OMIT_WINDOWFUNC`) from the DISTINCT-to-GROUP-BY
transformation.

This reverses the fix's single implementation hunk, which added `&& p->pWin==0`
to that same condition. In 3.54.1 the condition has more terms
(`sqlite3CopySortOrder`, `OptimizationEnabled`) but the `p->pWin==0` term is the
same guard, so removing it restores the pre-fix behaviour: a DISTINCT sub-select
with window functions whose ORDER BY equals its select list is rewritten to a
GROUP BY query.

## Oracle failure
`window1-33.2` (`SELECT (SELECT DISTINCT sum(aa) OVER() FROM t1 ORDER BY 1), x
FROM t2 ORDER BY 1`) aborts with
`sqlite3VdbeExec: Assertion 'memIsValid(pRec)' failed`.
