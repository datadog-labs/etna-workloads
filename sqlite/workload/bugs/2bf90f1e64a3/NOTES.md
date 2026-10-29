Reproducer for ticket #3530 (tkt3346-2.1): a subquery in the FROM clause must not
resolve column references against its own alias in the enclosing query.

`repro.sql` runs `SELECT * FROM (SELECT * FROM t1 WHERE 1=x.a) AS x;`.
Clean shell: `Parse error: no such column: x.a`. Buggy shell: the query resolves
the outer reference and runs instead of raising that error.
