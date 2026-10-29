Reproducer: LEFT JOIN with `WHERE a IN (1,3,x,y)`, where t2 is empty.
The IN expression doesn't imply a NOT NULL t2 row, so the LEFT JOIN must not be
reduced to an inner join. The clean shell returns both t1 rows with NULLs for t2
(`1|2|||x` and `3|4|||x`); the buggy shell wrongly reduces the join and returns no rows.
