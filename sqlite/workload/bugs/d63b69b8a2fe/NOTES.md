Reproducer (repro.sql): creates an index whose expression contains a CTE using `SELECT *` with no FROM,
then runs ALTER TABLE ... RENAME COLUMN. Clean shell reports "error in index k: no tables specified".
Buggy shell lacks the `pParse->nErr` check in renameUnmapSelectCb(), so the ALWAYS() assertion fails (or the result differs).
