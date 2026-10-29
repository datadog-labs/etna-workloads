Reproducer: `repro.sql` (where-18.1). A DISTINCT query does a LEFT JOIN whose right-table column appears only in ORDER BY.
The bug makes the omit-noop-left-join optimization ignore ORDER BY columns, so the join loop is dropped but ORDER BY still reads it.
Clean shell prints `1`. Buggy shell aborts with assertion `pC!=0` in sqlite3VdbeExec (exit -6).
