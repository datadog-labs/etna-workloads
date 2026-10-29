repro.sql runs `SELECT count(DISTINCT c) FROM t1 LEFT JOIN t2` (distinctagg-6.1).
Clean shell prints 1. Buggy shell aborts with assertion `pC!=0` in sqlite3VdbeExec
(exit -6) because the no-op-join omission is wrongly applied to aggregate DISTINCT queries.
