# Rationale

Fix hunk (src/build.c, sqlite3CreateIndex): when `sqlite3MPrintf("sqlite_autoindex_%s_%d")`
returns NULL because of SQLITE_LIMIT_LENGTH, set `pParse->rc = SQLITE_TOOBIG` and
`pParse->nErr++` before `goto exit_create_index`.

In 3.54.1 that build.c code is unchanged (no error set), but the same defect is covered by
another path: `sqlite3StrAccumSetError()` in src/printf.c now calls
`sqlite3ErrorToParser(p->db, SQLITE_TOOBIG)`, which records the error in the parser
(rc + nErr). That is the same job the fix's two added lines did.

Change: removed that one line in src/printf.c. With it gone, a TOOBIG printf failure in
sqlite3CreateIndex leaves pParse->nErr==0, exactly as before the fix.

Oracle failure: sqllimits1-17.1 (CREATE TABLE with a 10000-char name and
LIMIT_LENGTH 10000, PRIMARY KEY) aborts with
`sqlite3EndTable: Assertion (p->tabFlags & TF_HasPrimaryKey)==0 || p->iPKey>=0 ||
sqlite3PrimaryKeyIndex(p)!=0 failed`, the assert the fix's test comment mentions.
