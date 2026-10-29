Reproducer (repro.sql) is window1-48.0: a query with two window functions (`max(x)OVER(ORDER BY x)`, `min(x)OVER(ORDER BY x)`) whose ORDER BY contains a subquery, which can't be proven identical.

Clean shell prints 12/12/12. The buggy shell collapses the "can't tell" result (2) to 1, so the assert in windowAggStep fails and the shell aborts (exit -6).
