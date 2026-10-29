repro.sql: a parent table with INTEGER PRIMARY KEY `a` and UNIQUE(a,b) is referenced by a compound foreign key (x,y)->(a,b). A no-op `UPDATE p SET b=200 WHERE a=100` should succeed.

Clean: the UPDATE succeeds and the SELECT returns one row (exit 0).
Buggy: the UPDATE fails with "FOREIGN KEY constraint failed" (exit 1), because the rowid column is read from the wrong register in fkScanChildren.
