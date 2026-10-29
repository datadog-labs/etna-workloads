repro.sql: t1 has CHECK(b>a), t2 has none. `INSERT INTO t1 SELECT * FROM t2` with row (9,1).
Clean: fails with "CHECK constraint failed: b>a", t1 stays empty.
Buggy: the xfer optimization ignores the differing CHECK constraints, so the row is copied
unchecked and SELECT returns 9|1.
