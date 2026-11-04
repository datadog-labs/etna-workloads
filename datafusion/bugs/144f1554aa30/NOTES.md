repro.sql builds a small table and runs the nested-filter query from the fix's slt test, plus `int_col >= 1 AND int_col > 1`.
When bounds are equal, the buggy simplify_predicates keeps the looser operator (>= over >, <= over <).
Buggy build returns extra rows (e.g. int_col=1, which violates `> 1`; and 11 in the nested query, which violates `< 10`). The clean build returns the correct rows.
The EXPLAIN predicate also differs (`>= 1 AND <= 10` vs `> 1 AND < 10`).
