repro.sql builds the rowvalue4-5.0 schema (d1, d2 with indexes d2ab, d2c; 1000 rows; ANALYZE) and runs EXPLAIN QUERY PLAN on
`(a,b) IN (SELECT ..) AND (c) IN (SELECT ..)`.
Clean: `SEARCH d2 USING INDEX d2ab (a=? AND b=?)`. Buggy: `SCAN d2`, because nIn isn't reset in whereLoopAddBtreeIndex, so the vector IN cost is wrong and the d2ab plan isn't chosen.
