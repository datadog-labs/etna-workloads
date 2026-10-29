repro.sql builds join5-7.1's t1/t2 (50000 rows, index t2(x,y), ANALYZE) and runs EXPLAIN QUERY PLAN on
`t1 LEFT JOIN t2 ON (t2.x=t1.x AND (t2.y=? OR (t2.y=? AND t2.z IS NOT NULL)))` (join5-7.2).
Clean: both multi-index-OR branches use `SEARCH t2 USING INDEX t2xy (x=? AND y=?) LEFT-JOIN`.
Buggy: the branches degrade to `SCAN t2 LEFT-JOIN`, because the ON-clause terms are no longer handled correctly in the OR-subclause code.
