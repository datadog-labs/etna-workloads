repro.sql builds t1(a,b,c) with an index on c, plus t2, then runs `t1 LEFT JOIN t2 ON x=b AND 1=c`.
Clean: returns both t1 rows (2|4|NULL for the non-matching row) and scans t1.
Buggy: the ON-clause term `1=c` is used to drive index i1 on the left table, so row 2 is dropped (wrong result); the query plan also differs.
