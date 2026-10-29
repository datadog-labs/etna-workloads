repro.sql: two tables with one column each; runs `sum(b ORDER BY a)` and `group_concat(b ORDER BY a)` over a cross join.
Clean shell prints 2 and 2. Buggy shell prints 42 and 42, because the ORDER BY term `a` (t1 col 0) is wrongly judged identical to the argument `b` (t2 col 0), so the argument is replaced by the sort key.
