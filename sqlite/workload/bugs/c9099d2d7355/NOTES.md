Creates the join-28 schema (view t3 = t1 LEFT JOIN t2) and runs EXPLAIN QUERY PLAN
on `SELECT a,b,y FROM t4 JOIN t3 ON a=x`. Clean: the view is flattened and t2 is
omitted (SCAN t4, SEARCH t1). Buggy: the injected restriction (29) blocks flattening,
so the plan differs (the view is materialized/co-routine).
