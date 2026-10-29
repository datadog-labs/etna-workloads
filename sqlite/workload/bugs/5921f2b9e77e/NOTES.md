repro.sql creates an FTS5 table, inserts a row inside a transaction, then renames the table (ALTER TABLE ... RENAME) in the same transaction and commits.
The rename issues an FTS5 savepoint with the same index as the current one. The clean shell prints `a|b|c`. The buggy shell aborts with `Assertion 'iSavepoint>p->ts.iSavepoint' failed` in fts5CheckTransactionState (exit status -6).
