Table t5 has column m; the query selects `substr(m,2,1) AS m` and does `GROUP BY m`.
GROUP BY must bind to the input column t5.m. Clean shell returns 3 groups: `1|x`, `1|x`, `1|y`.
The buggy shell resolves GROUP BY m as the AS alias, so it returns 2 rows: `1|y` and `2|x`.
