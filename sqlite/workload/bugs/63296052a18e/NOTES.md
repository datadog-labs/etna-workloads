# Reproducer

`repro.sql`:

```sql
SELECT 1 FROM (SELECT *);
```

A `SELECT *` with no FROM clause (and thus no tables to expand `*` against)
is invalid SQL. `selectColumnsFromExprList()` is called with a NULL
`pEList` for this subquery, since the `*` has not been expanded into any
expressions.

- **Clean shell**: handles the NULL `pEList` case, reports a clean parse
  error (`no tables specified`) and exits with status 1.
- **Buggy shell** (`injection.patch` applied, reverting the fix from
  commit 63296052a18e): dereferences the NULL `pEList` pointer
  (`pEList->nExpr`), crashing with a segmentation fault (exit status -11,
  i.e. SIGSEGV).

This matches the test added by the fix (`select1-16.1` in
`test/select1.test`), which exercises exactly this query.
