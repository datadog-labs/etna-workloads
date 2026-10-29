Reproducer (repro.sql) is join2-9.10: a LEFT JOIN against a view `SELECT bbb IS 1234 FROM t2` (empty t2),
then `ccc IS NULL`. The query flattener wraps the substituted expression in TK_IF_NULL_ROW.
Clean shell prints `|1` (ccc is NULL); buggy prints `|0` because sqlite3ExprAffinity/skip logic
mishandles the IF_NULL_ROW wrapper, so `IS NULL` is evaluated wrongly.
