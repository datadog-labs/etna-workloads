repro.sql: INSERT INTO temp t2 SELECT * FROM t1 RETURNING * (upstream returning1-16.0).
Clean shell prints the returned rows, then the table contents.
Buggy shell takes the xfer optimization despite RETURNING (the RETURNING trigger counts as a trigger) and aborts: sqlite3Insert: Assertion `!pTrigger' failed (exit -6).
