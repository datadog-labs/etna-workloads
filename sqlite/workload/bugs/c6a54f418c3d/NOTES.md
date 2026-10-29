Reproducer (`repro.sql`): the in-23.0 case from test/in.test. It creates t4 with an
index on (a, +a COLLATE NOCASE) and runs a GROUP BY/HAVING query whose subquery
uses `(a1.a == +a0.a COLLATE NOCASE) IN (SELECT b FROM t4)`.

Clean shell: prints three rows, exit 0.
Buggy shell: the assert() re-added by injection.patch in sqlite3FindInIndex
(`pReq!=0 || pRhs->iColumn==XN_ROWID || pParse->nErr`) fails and the shell aborts (status -6).
