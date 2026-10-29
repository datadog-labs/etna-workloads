repro.sql: table with INTEGER PRIMARY KEY, query `WHERE i IN (...) ORDER BY j DESC LIMIT 3`.
Clean shell returns 5,3,2 (correct). Buggy shell skips the IPK+IN exclusion in wherePathSolver, so the
ORDER BY LIMIT optimization is wrongly applied and it returns 3,2,1 (wrong rows).
