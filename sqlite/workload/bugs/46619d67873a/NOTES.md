Table t1 with a UNIQUE index on b, where b is NULL in every row. The query
`SELECT a FROM t1 WHERE b IS NULL ORDER BY a` must sort, since `b IS NULL` can
match many rows even on a UNIQUE index (ticket #3824).

Clean shell: rows come back sorted (-10 1 5 9 123) and the plan has
`USE TEMP B-TREE FOR ORDER BY`. Buggy shell: the optimizer wrongly treats the
lookup as single-row and skips the sort, so rows come back unsorted
(1 9 5 123 -10) and the plan has no sorter.
