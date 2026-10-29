# Reproducer notes

`repro.sql` covers `test/altertab.test` case 31 (31.0-31.3): it creates a
view whose body is a CTE `x` that itself contains a nested CTE `y` which
refers back to `x`, forming a loop in the WITH clause. After selecting from
the view once (forcing the CTE to be expanded/copied), it runs
`ALTER TABLE ... RENAME TO` and `ALTER TABLE ... RENAME COLUMN`.

Difference between shells:
- `bin/sqlite3-clean`: exits 0, prints `1` for the `SELECT * FROM vvv`,
  both ALTER TABLE statements succeed silently.
- `bin/sqlite3-buggy`: prints the same `1`, but then crashes (killed by a
  signal, exit status -11) while processing the ALTER TABLE statements.

The fix added the `SF_CopyCte` flag so that the ALTER TABLE renaming
walkers (`renameUnmapSelectCb`, `renameColumnSelectCb`,
`renameTableSelectCb`) prune select trees that are copies of CTEs, the
same way they already prune views. Without that flag (the injected bug),
the walker re-descends into the duplicated, self-referential CTE select
tree during ALTER TABLE and recurses without bound, causing a stack
overflow/crash.
