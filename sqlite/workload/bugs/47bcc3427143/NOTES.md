## Reproducer

`repro.sql` (taken directly from the test case added by `fix.patch`,
window1-32.10):

```sql
CREATE VIEW a AS SELECT NULL INTERSECT SELECT NULL ORDER BY s() OVER R;
CREATE TABLE a0 AS SELECT 0;
ALTER TABLE a0 RENAME TO S;
```

The view's compound SELECT has an `ORDER BY` term that references an
undefined window (`s() OVER R`), which is invalid and should fail to
resolve. `ALTER TABLE ... RENAME TO` forces SQLite to re-parse the view's
SQL text (to fix up the renamed table reference), re-triggering that
failed resolution.

In `sqlite3WindowLink()`, the window being linked (`pWin`, for `s() OVER R`)
belongs to a sub-`Select` of the compound (the `ORDER BY` term gets
resolved against a wrapped SELECT), but the call that links it passes a
`pSel` that can be NULL in this error path. The pre-fix code dereferences
`pSel->pWin` unconditionally; the fix (commit 47bcc34271) added a
`pSel != 0` guard. `injection.patch` removes that guard again, reinstating
the NULL pointer dereference.

## Observed difference

- `bin/sqlite3-clean` (fixed): exits with status 1 and prints the expected
  resolver error:
  `Error near line 3: error in view a: 1st ORDER BY term does not match any column in the result set`
- `bin/sqlite3-buggy` (bug reinjected): crashes with SIGSEGV (exit status
  -11) on the NULL pointer dereference in `sqlite3WindowLink()`.
