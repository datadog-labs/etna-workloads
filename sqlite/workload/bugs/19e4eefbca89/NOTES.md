Reproducer (repro.sql) is rowvalue-30.0..30.2: a row-value UPDATE ... FROM whose
subquery uses a window function (max OVER PARTITION BY sum((SELECT t1.y))).
Clean shell prints `1000|2`. Buggy shell aborts with
`sqlite3Select: Assertion 'pExpr->iAgg==i' failed` (exit -6), because
analyzeAggregate no longer short-circuits when the aggregate Expr is already registered.
