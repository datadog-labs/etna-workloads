repro.sql is in4.test case 13.0: a table with index t1x(a,b,c) and a faked sqlite_stat1 row, then
`SELECT ... WHERE a=1 AND b IN (2,3) AND c BETWEEN 4 AND 5 ORDER BY +id`.
Clean shell returns all 4 rows. Buggy shell drops row `20|1|3|5`, because OP_SeekScan can skip
the code that sets the range-end value.
