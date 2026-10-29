repro.sql: a CTE selects `Row_Number() OVER (win)` from a table with a named `WINDOW win AS (PARTITION BY ...)`.

Window dup (when the CTE is expanded) fails to copy zBase and bImplicitFrame in the buggy build.
- Clean: first query returns 1,1 (each partition has one row). The second query, with a bad column in the WINDOW, errors with "no such column: fake_column" (exit 1).
- Buggy: the first query returns 1,2 (the PARTITION BY is lost). The second query runs without error and returns 1,2 (exit 0).
