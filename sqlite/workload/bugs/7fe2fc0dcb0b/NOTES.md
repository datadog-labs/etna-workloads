repro.sql: a table with a generated column and a self-referencing foreign key on the rowid alias, then INSERT OR REPLACE (the gencol1-11.20 case).
Clean: 'FOREIGN KEY constraint failed', exit 1. Buggy: assertion failure memIsValid in sqlite3VdbeExec (abort), because sqlite3TableColumnToStorage mishandles iCol<0 (rowid).
