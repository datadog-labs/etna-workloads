Reproducer (repro.sql): create a table and index, run ANALYZE (creates sqlite_stat1), then
ALTER TABLE ... RENAME COLUMN, and try to rename a column of sqlite_stat1.

Clean: rename succeeds (SELECT returns 2, 5); renaming sqlite_stat1 gives "table sqlite_stat1 may not be altered".
Buggy: the rename fails with "error in table sqlite_stat1: object name reserved for internal use",
so the column is not renamed; the sqlite_stat1 rename gives the same wrong error.
