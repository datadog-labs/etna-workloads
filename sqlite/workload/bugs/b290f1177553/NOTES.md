repro.sql: a CTE `x1` referenced from a scalar subquery in the outer SELECT
(`WITH x1 AS (SELECT * FROM t1) SELECT (SELECT sum(a) FROM x1);`).
Clean shell prints 3. Buggy shell fails with "Parse error: no such table: x1",
because the WITH clause is not on the stack when the subquery is name-resolved (with2-1.2/1.3).
