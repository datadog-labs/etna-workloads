repro.sh builds a db with t1(a INTEGER PRIMARY KEY, b), uses writable_schema (defensive off) to rewrite its SQL to add AUTOINCREMENT, then reopens and runs ALTER TABLE t1 DROP COLUMN b.
Clean: succeeds, schema becomes `CREATE TABLE t1(a INTEGER PRIMARY KEY AUTOINCREMENT)`.
Buggy: "error in table t1 after drop column: incomplete input", schema unchanged, exit 1 (the AUTOINCREMENT handling in sqlite3EndTable runs during the special parse).
