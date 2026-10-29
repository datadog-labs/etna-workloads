Reproducer (`repro.sql`): the LEFT JOIN strength-reduction case from rowvalue-26.30. t1 has one row and t0 is empty, and the query is `SELECT 3 FROM t1 LEFT JOIN t0 WHERE (c0, x'') != (NULL, 0)`.

Clean shell: prints `3`. The row-value comparison is true, because `x'' != 0` is true and `NULL` is ignored.
Buggy shell: prints nothing. Without the `TK_VECTOR` case, `sqlite3ExprImpliesNonNull()` wrongly decides the WHERE clause rejects NULL `c0`. It turns the LEFT JOIN into an inner join, and the row is lost.
