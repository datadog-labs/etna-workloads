repro.sql: LEFT JOIN with `WHERE ~('x'='y' AND t2.y=1)` (join-15.106b).
Buggy shell treats AND as implying non-null-row, so the LEFT JOIN is reduced to an inner join and the rows (1 2 NULL NULL x / 3 4 NULL NULL x) disappear. Clean shell returns both rows.
