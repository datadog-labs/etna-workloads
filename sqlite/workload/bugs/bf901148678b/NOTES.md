Reproducer (repro.sql) is join2-10.2: a correlated scalar subquery does `t2 LEFT JOIN (SELECT x AS v FROM t3) ON 500=v WHERE (v OR FALSE)`, where `x` resolves to the outer query's t1.
Flattening the view on the right of the LEFT JOIN should wrap every reference to `v` in TK_IF_NULL_ROW, including plain TK_COLUMN nodes. The injected bug skips that wrap when the copy is a TK_COLUMN.
Clean shell prints NULL. Buggy shell prints 1, which is wrong because the join row is NULL-extended and `v` should be NULL.
