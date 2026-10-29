`repro.sql` is the with1-12.1 query. It uses two recursive CTEs and a compound SELECT (`EXCEPT`) with `ORDER BY`.

- Clean shell: prints `2 4 8 10 14 16 20`, exit status 0.
- Buggy shell: `Parse error near line 1: no such table: t1`, exit status 1.

With the bug, `sqlite3SelectPopWith` only pops the WITH clause when the select has its own `pWith`. In a compound query the WITH clause is attached to the rightmost select. It never gets popped there, so the CTE names don't resolve for the left-hand selects.
