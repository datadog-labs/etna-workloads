# Rationale

Fix hunk (src/build.c, sqlite3FinishCoding): `if( pAinc!=0 && nTab==0 ) nTab = 1;`
guaranteed one VDBE cursor when autoincrement is used.

In 3.54.1 that logic lives in `sqlite3AutoincrementBegin()` (src/insert.c):
`if( pParse->nTab==0 ) pParse->nTab = 1;`. The build.c site now only holds the
comment and `assert( pParse->usesAinc==0 || pParse->nTab>0 )`.

Change: removed that line from `sqlite3AutoincrementBegin()`. Autoincrement
code opens the sqlite_sequence table on cursor 0 but no longer reserves it,
which is the pre-fix behaviour. The existing assert in sqlite3FinishCoding is
kept; it detects the condition (without asserts, the program would be built with
too few cursors).

Oracle: autoinc-a69637.2 (INSTEAD OF trigger on a view inserting into an
AUTOINCREMENT table) fails with
`Assertion 'pParse->usesAinc==0 || pParse->nTab>0' failed` in sqlite3FinishCoding.
