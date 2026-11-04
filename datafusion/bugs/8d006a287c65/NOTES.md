Reproducer: the query from the upstream fix (issue #14352) in union.slt. It does a UNION ALL of `'foo' AS a` and `NULL AS a`, then selects `a, a IS NOT NULL` from it.

Clean build: the NULL row gives `a IS NOT NULL` = false.
Buggy build: the NULL row gives true. The union schema takes nullability from the first branch only, so `a` is treated as non-null and the optimizer simplifies `a IS NOT NULL` to true.
