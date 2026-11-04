repro.sql runs a recursive CTE whose recursive term joins `generate_series(1, 1)` (a LazyMemoryExec) with the CTE, LIMIT 10.
Without `reset_state` on LazyMemoryExec, the generator is exhausted after the first iteration and is not reset.
- df-clean: 10 rows of `1`.
- df-buggy: only 2 rows of `1`.
(The query has no ORDER BY: all rows are equal, and ORDER BY + LIMIT never terminates on the recursion.)
