repro.sql builds t3(a,b,c) with one row and an index on an expression (a+1, then a+c), then runs
`SELECT * FROM (SELECT 99), t3 WHERE a=0 AND a+1=(SELECT 1)` and the a+c variant.
The scalar subquery is a constant expression that matches the indexed expression. The buggy
shell reads it from the index outside the indexed loop, so both queries return no rows.
The clean shell returns `99|0|xyzzy|1` for each.
