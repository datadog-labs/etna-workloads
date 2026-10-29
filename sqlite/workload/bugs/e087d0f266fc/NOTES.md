`repro.sql` queries the generate_series virtual table with a WHERE clause of the form
`(start=1 AND stop=3) OR (start=1 AND stop=2 COLLATE nocase)`. This is a shell-level analogue of
bestindexC-5.8/5.9 (which need a TCL vtab).

- clean: the OR term is not analyzed because it contains COLLATE, so `start` is unusable and the
  query fails with `first argument to "generate_series()" missing or unusable` (exit 1).
- buggy: the OR-optimization is attempted, `start=1` is factored out of both branches and the
  query succeeds, printing 1 2 3 (exit 0).
