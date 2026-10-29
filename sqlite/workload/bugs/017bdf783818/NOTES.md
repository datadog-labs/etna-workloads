Reproducer (`repro.sql`): the forum-post query from window1-76.1. A window function inside a correlated
subquery references a column from the LEFT JOIN'd subquery, with GROUP BY.

Clean shell prints `111|112` and `118|119`. The buggy shell (analyzeAggregate returns WRC_Continue
and window.c skips TK_IF_NULL_ROW) aborts with `Assertion 'pC!=0' failed` in sqlite3VdbeExec (exit -6).
