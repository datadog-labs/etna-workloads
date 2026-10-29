repro.sql builds the altertab-33.0 schema (trigger with an UPDATE ... FROM whose ON clause has a nested subquery
referencing column a) and runs ALTER TABLE t1 RENAME COLUMN a TO b, then a SELECT.

Clean: "error in trigger r3 after rename: no such column: a", then the SELECT returns NULL, 'abc', 'def'.
Buggy: aborts with an assertion failure in sqlite3ExprAffinity (exit status -6).
