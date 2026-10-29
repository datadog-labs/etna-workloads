Reproducer (`repro.sql`): a UNION ALL subquery in FROM whose arms have different
column counts (`SELECT i FROM t UNION ALL SELECT l, m FROM j`).

Clean shell: parse error "SELECTs to the left and right of UNION ALL do not have the same number of result columns", exit 1.
Buggy shell: the check in resolve.c is removed, so the assertion
`pTab->nCol==pSelect->pEList->nExpr || pParse->nErr>0` in sqlite3SubqueryColumnTypes fails (abort, exit -6).
