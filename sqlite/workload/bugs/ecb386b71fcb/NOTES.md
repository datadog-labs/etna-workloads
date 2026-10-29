repro.sql is the join8-5000 case from the fix: a correlated subquery doing
`sqlite_temp_schema FULL JOIN t2 ... ORDER BY d` (ORDER BY LIMIT optimization with a right-join innermost loop).

Clean shell: exits 0 and prints two blank (NULL) rows.
Buggy shell: aborts with an assertion failure in sqlite3VdbeExec (`pOp->p1!=SQLITE_INTERNAL`), exit status -6 (SIGABRT),
because the optimization jumps out of the right-join body subroutine.
