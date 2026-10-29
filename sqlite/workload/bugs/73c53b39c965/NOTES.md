Reproducer (`repro.sql`): builds a view that is a UNION ALL of two selects, then runs
`SELECT count(*) FROM v1 WHERE x<>1` and `... GROUP BY y`.

The injection removes the WHERE and GROUP BY guards from the count-of-view optimization.
Clean shell prints 4, 3, 3. Buggy shell aborts (exit -6) with the assertion `pC!=0` in sqlite3VdbeExec.
