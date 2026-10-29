Reproducer (repro.sql): EXPLAIN of `SELECT count(*) FROM t2 WHERE d IN (SELECT DISTINCT a FROM t1)`.
Clean shell ignores DISTINCT on the IN RHS and uses the rowid of t1 directly (no ephemeral-table build);
the buggy shell treats DISTINCT as disqualifying the IN optimization, so the bytecode differs
(ephemeral index + bloom filter is built). Only the query plan differs, not the query result.
