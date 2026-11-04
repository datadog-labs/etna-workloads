Reproducer for EliminateGroupByConstant dropping all GROUP BY exprs when they are all constant.

repro.sql creates an empty table and runs `SELECT AVG(v1) FROM t1 GROUP BY false` (also with `HAVING false`),
then inserts rows and reruns it.
On the empty table the clean build returns zero rows (grouped aggregate on empty input).
The buggy build turns it into a global aggregate and returns one row (`NULL`).
The non-empty case returns the same result on both builds (2.0).
