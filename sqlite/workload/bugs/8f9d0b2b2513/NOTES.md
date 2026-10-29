The bug: `withExpand()` in `select.c` checks `pEList->nExpr != pCte->pCols->nExpr`
without first checking that `pEList` is non-NULL. `pEList` is NULL when the
left-most SELECT of a recursive CTE's compound body is a bare `SELECT *` with
no FROM clause (a wildcard with no table to expand against), which is itself
an error condition that should be reported before this NULL is dereferenced.

repro.sql defines a recursive CTE `c(i)` whose base case is
`SELECT * UNION ALL SELECT i+1 FROM c WHERE i<10` and selects from it. The
base-case `SELECT *` has no FROM clause, so `pEList` is NULL by the time the
buggy code dereferences it.

- Clean shell: reports a parse error, `no tables specified`, exit status 1.
- Buggy shell: dereferences the NULL `pEList`, crashing with SIGSEGV
  (exit status -11).
