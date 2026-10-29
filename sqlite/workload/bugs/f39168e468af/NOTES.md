`repro.sql` runs the having-5.1 case from the fix. The outer query is an aggregate (`min(b)`). Its subquery has a correlated WHERE (`a=2`) and `GROUP BY y HAVING 0`.

- Clean shell: prints `b|` and exits 0.
- Buggy shell: aborts with `Assertion 'pExpr->pAggInfo==pAggInfo' failed` in sqlite3Select. The cause is that the HAVING-to-WHERE push-down turns `a=2 AND 0` into plain `0`, which breaks the outer query's aggregate processing.
