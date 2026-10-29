Reproducer (repro.sql): a recursive CTE whose initial SELECT is `SELECT DISTINCT * FROM t` (UNION ALL) over a table with a duplicate row (a,1).
Clean shell returns each row once (a 1..3, b 1..3). The buggy shell ignores DISTINCT in the UNION ALL initial select (the queue destination is treated as ignorable), so the duplicate a rows appear twice.
