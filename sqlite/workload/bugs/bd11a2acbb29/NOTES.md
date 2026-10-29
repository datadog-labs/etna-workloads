Reproducer (repro.sql) is the join-14.20 case: t1 LEFT JOIN (SELECT * FROM t2) x2 LEFT JOIN t3 ON x2.id=x3.c3.
Clean shell returns one row `456||`. Buggy shell wrongly returns two rows (`456||1`, `456||2`), because after
flattening the subquery the planner no longer treats the NOT NULL rowid column x2.id as possibly NULL.
