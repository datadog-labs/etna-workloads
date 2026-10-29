Reproducer: `repro.sql` runs `SELECT DISTINCT` with 65 constant result terms and `ORDER BY` with 64 constant terms (distinct.test 10.x, tickets c36cdb4afd504dc1 etc.).
Clean shell prints the single row. Buggy shell aborts on assertion `pWInfo->pSelect->pOrderBy==0 || pWInfo->nOBSat <= pWInfo->pSelect->pOrderBy->nExpr` in wherePathSolver (nOBSat is not clamped to the ORDER BY term count).
