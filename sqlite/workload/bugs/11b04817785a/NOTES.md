repro.sql runs `SELECT 986 AS x GROUP BY X ORDER BY X;` (GROUP BY plus ORDER BY, no FROM clause; orderby1-5.3).
Clean shell prints 986 and exits 0. Buggy shell crashes with SIGSEGV (exit status -11) because wherePathSolver evaluates the SORTBYGROUP check with nLoop==0.
