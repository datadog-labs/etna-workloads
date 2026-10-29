repro.sql builds the count-7 table with an index and fake stat1 rows so the index is
narrower than the table, then runs EXPLAIN QUERY PLAN on `SELECT count(*) FROM t1 NOT INDEXED`.
Clean: `SCAN t1`. Buggy: `SCAN t1 USING COVERING INDEX t1b`, because the count
optimization ignores NOT INDEXED.
