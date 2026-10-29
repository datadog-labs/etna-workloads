repro.sql: creates a WITHOUT ROWID table with a duplicated PRIMARY KEY column, `PRIMARY KEY(a, a, b)` where b is COLLATE nocase. It then inserts ('one') and ('ONE') with the same a.

Clean: the second row violates the PK, so it fails with "UNIQUE constraint failed: t1.a, t1.b" (exit 1).
Buggy: when the duplicate column is dropped, the collation and sort order are no longer shifted down with the column. b gets the wrong (BINARY) collation, so both rows insert without error (exit 0).
