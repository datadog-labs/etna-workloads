repro.sql flattens a UNION ALL subquery whose second branch has a RIGHT JOIN (unionall2-3.2/3.4).
Clean shell: query 1 returns no rows, query 2 returns `7`.
Buggy shell: query 1 returns an extra empty row, query 2 returns `5` and `7`.
Cause: the buggy flattener takes the join flags from the wrong FROM-clause item, so the parent's join flags are wrong.
