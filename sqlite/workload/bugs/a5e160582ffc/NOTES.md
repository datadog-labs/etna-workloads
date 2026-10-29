repro.sql: a correlated scalar subquery `SELECT COUNT(*) FROM (SELECT 1 UNION ALL SELECT SUM(c1))`
references outer column c1 from inside an inner compound subquery.
Clean shell: `Parse error: misuse of aggregate: SUM()`. Buggy shell: the count-of-view
optimization is applied to the correlated subquery, so the error is not raised
(the query returns a result instead).
