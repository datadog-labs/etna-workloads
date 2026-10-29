Reproducer (repro.sql): table with a NOCASE column c0, a partial index `WHERE c0 >= c1`, and one row ('a','B').
The query `SELECT 2 FROM t0 WHERE c1 <= c0` is the commuted form of the index's WHERE clause, but with c0's NOCASE collation it is not equivalent.
Clean shell: prints `2` (the row is returned). Buggy shell: prints nothing, because the buggy exprCompare ignores EP_Commuted and wrongly uses the partial index as implied by the WHERE term.
