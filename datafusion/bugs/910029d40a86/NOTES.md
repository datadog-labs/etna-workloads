Reproducer for the count-bug-like decorrelation bug (scalar subquery with a non-count aggregate wrapped in an expression).
repro.sql creates t1/t2 (from subquery.slt) and runs two correlated scalar subqueries:
`CASE WHEN max(t2_id) > 1 THEN 'a' ELSE 'b' END` and `max(t2_id) IS NULL`.
Clean: unmatched rows (t1_id 22, 44) give 'b' / true. Buggy: they give NULL / NULL.
