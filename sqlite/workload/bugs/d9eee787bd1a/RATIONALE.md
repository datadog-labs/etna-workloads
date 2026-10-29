# Rationale

Single hunk in `tree/src/build.c`, `sqlite3EndTable()` CREATE TABLE ... AS SELECT path. It reverses the `src/build.c` hunks of fix.patch:

- Removed the `iCsr = pParse->nTab++` allocation. Restored the hard-coded cursor 1 for OP_OpenWrite, OP_NewRowid, OP_Insert and OP_Close.
- Restored `assert( pParse->nTab==1 )` and `pParse->nTab = 2` after OpenWrite.

The pre-fix code assumed no cursors had been allocated before the SELECT was coded. The VALUES-as-coroutine optimization can allocate cursors earlier, so nTab is not 1. Cursor 1 can then collide with a cursor the SELECT uses, or the assert fires.

Oracle failure: values-17.1 (`CREATE TABLE t1 AS SELECT * FROM (VALUES(1,2),(3,4 IN (1,2,3)))`) hits `Assertion pParse->nTab==1 failed` in sqlite3EndTable. Without asserts it would give wrong results or a crash, so 17.2 and later cases are lost too.
