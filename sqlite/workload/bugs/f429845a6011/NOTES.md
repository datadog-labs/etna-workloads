`repro.sql` is join-20.3 without the TCL harness. It runs a RIGHT JOIN followed by a LEFT JOIN, where the RIGHT JOIN's table has a partial index `WHERE y`, and selects `quote(z)`.

- Clean shell: prints `NULL`. The ON term `y` is false, so t3 has no match.
- Buggy shell: prints `3`, a wrong result. The injection removes the `pLevel->pRJ==0` check. That lets the partial-index WHERE clause cancel the `y` term on the RIGHT JOIN loop, and the LEFT JOIN to t3 then matches.
