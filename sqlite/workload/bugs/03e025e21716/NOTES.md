repro.sql: inside a transaction that wrote to an FTS5 virtual table, runs ALTER TABLE ADD COLUMN on an ordinary table.
Clean shell: no output, exit 0. Buggy shell: assertion failure in sqlite3FinishCoding (isMultiWrite without mayAbort), abort (exit -6),
because the injection removes sqlite3MayAbort() from ADD COLUMN and from the ParseSchema with a WHERE clause.
