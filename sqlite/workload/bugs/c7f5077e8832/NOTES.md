Reproducer (repro.sql): the unionall-7.1 query, a recursive CTE with two recursive terms joined with a UNION ALL subquery that also reads the CTE.
Clean shell returns 12 correct rows. The buggy shell, whose UNION ALL flattener renumbers recursive-CTE cursors unconditionally, hits `Assertion 'pC!=0' failed` in sqlite3VdbeExec (abort, status -6).
