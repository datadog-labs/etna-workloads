Reproducer (repro.sql) is tkt-99378-400: an aggregate view with GROUP BY on a term not in the result set (`avg(w) ... GROUP BY w>1`), used in a subquery of a query that can use an expression index (`t1x` on `x>0`).
Clean prints 0, 0. Buggy prints 0, 1 for the INDEXED BY query, because the sorting-column count is computed wrongly and gives a wrong answer.
