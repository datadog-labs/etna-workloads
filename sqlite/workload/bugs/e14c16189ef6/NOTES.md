repro.sql: src and dest both have `CHECK(rowid<=5)` and no INTEGER PRIMARY KEY; dest has 3 rows, then `INSERT INTO dest SELECT * FROM src` adds 3 more (rowids 4-6).
Clean: the xfer optimization is skipped, so the insert fails with "CHECK constraint failed: c2" and dest keeps 3 rows.
Buggy: the xfer optimization runs and bypasses the CHECK, so rowid 6 is inserted. The insert succeeds and integrity_check reports "CHECK constraint failed in dest".
