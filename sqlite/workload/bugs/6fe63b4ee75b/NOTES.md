repro.sql queries the dbstat virtual table with `aggregate = NULL` and `aggregate = 5`.
The buggy shell omits the `aggregate` equality constraint, so SQLite does not re-check it.
Clean output: `0`, then no rows for the second query. Buggy output: `2`, then two rows of `1`.
This is the failure in stat-8.2 and stat-8.3.
