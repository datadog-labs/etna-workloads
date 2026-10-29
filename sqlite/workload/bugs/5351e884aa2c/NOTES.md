repro.sql: a view v1 with an INSTEAD OF trigger using NEW.a, then ALTER TABLE t2 RENAME TO t3.
Clean: succeeds (tables t1, t3). Buggy: assertion failure `i<nCol` in sqlite3ColumnIndex
(exit -6), because renameResolveTrigger no longer loads the view's column names.
