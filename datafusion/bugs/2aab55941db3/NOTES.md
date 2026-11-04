`repro.sql` creates a small table and runs `EXPLAIN FORMAT TREE SELECT a FROM t1 WHERE a > 3 LIMIT 5;`.
The limit is pushed into FilterExec as `fetch`. df-clean renders `fetch: 5` in the FilterExec box of the tree plan. df-buggy omits it, because the injection removed the `fetch` line from FilterExec's TreeRender output.
