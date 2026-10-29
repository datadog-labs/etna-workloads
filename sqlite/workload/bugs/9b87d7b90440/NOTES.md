repro.sql runs `SELECT j1.b FROM (t1 INNER JOIN t2 ON a=c) AS j1;` and `SELECT a FROM (t1) AS t ON b;`.
Clean: the first query is accepted; the second fails with "a JOIN clause is required before ON".
Buggy: the parenthesized-join rule ignores the alias, so the first query fails with "no such column: j1.b" (tkt3935.3); the second would also lose its ON check (tkt3935.5), but the script stops at the first error.
