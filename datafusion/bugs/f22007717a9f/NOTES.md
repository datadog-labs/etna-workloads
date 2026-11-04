repro.sql sets target_partitions=4, creates the 4-row table from the upstream limit.slt test (#22489), and runs
an outer `ORDER BY sy DESC OFFSET 1` over a subquery with `GROUP BY ... ORDER BY sx DESC LIMIT 4`.

Clean build returns 3 rows (g=2,3,4). The buggy build leaks the outer OFFSET into the inner LIMIT
(LimitPushdown), so the inner fetch shrinks and g=4 is dropped (2 rows).
