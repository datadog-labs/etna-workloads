repro.sql renames column `a` in `CREATE TABLE t1('a'"b",c)` with an index on `'a'`.
Clean: rename succeeds, schema becomes `CREATE TABLE t1("x" "b",c)`.
Buggy: exit status 1, "error in index i1 after rename: no such column: "x"", and the table schema is left unchanged.
