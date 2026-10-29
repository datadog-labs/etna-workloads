Reproducer: `EXISTS (SELECT 1 FROM t0 LIMIT 0)` is always false, so the query should return no rows.
The injected bug lets the EXISTS-to-JOIN optimization apply to subqueries with a LIMIT, so it drops the LIMIT.
The buggy shell returns the row `2`. The clean shell returns nothing.
