repro.sql creates an rtree table, then adds a generated column to another table whose expression contains a subquery over the rtree (`c IN (SELECT 1 FROM t1)`).

- clean: `Error ... error in table t2 after add column: subqueries prohibited in generated columns`, exit 1.
- buggy: assertion failure `db->init.busy==0` in sqlite3_declare_vtab, abort (exit 134).
