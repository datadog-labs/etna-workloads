# Rationale

Fix hunk (src/build.c, createTableStmt): the fix dropped the `CREATE TEMP TABLE `
prefix so CTAS in the temp database records `CREATE TABLE ...`. Pre-fix,
createTableStmt took an `isTemp` argument and wrote `CREATE TEMP TABLE `.

In 3.54.1 the function writes `CREATE TABLE ` via memcpy and has no isTemp
parameter. I restored the parameter and the TEMP branch (`!OMIT_TEMPDB && isTemp`),
and the only caller (sqlite3EndTable, CTAS path) passes
`p->pSchema==db->aDb[1].pSchema` (the table lives in the temp database).
The buffer already reserves 35 extra bytes, enough for the 5 extra characters.

Failing oracle cases: tkt3630-2 (sqlite_temp_master sql contains
`CREATE TEMP TABLE temp2(a,b,c)`) and tkt3630-3 (ALTER TABLE ADD COLUMN on that
table fails with a syntax error, because the stored text is rewritten wrongly).
