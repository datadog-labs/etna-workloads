Reproducer (repro.sql): table t10 with an index on the expression a+b, then
`SELECT a+b, c+d FROM t10 ORDER BY a+b, c+d`.

The buggy where.c treats an expression-index column (iColumn==XN_EXPR, <0) like
the rowid when counting distinct columns, so the planner wrongly believes the
index already satisfies the full ORDER BY and skips the sort on c+d.
Clean shell returns rows sorted by (a+b, c+d); buggy shell returns
0|4, 0|0, 0|2, 2|2, 2|0, 4|0 (second key unsorted).
