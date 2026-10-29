repro.sql builds t1(a,b,c) with index t1bc(b,c), injects sqlite_stat1 rows (as orderby5 test 2.1a), then runs EXPLAIN QUERY PLAN on
`SELECT * FROM t1 WHERE likelihood(a=0,0.03) ORDER BY a,b,c`.
Clean: SCAN t1 + "USE TEMP B-TREE FOR LAST 2 TERMS OF ORDER BY". Buggy: SCAN t1 USING INDEX t1bc (sort cost is mis-estimated, so the sorter is not chosen).
