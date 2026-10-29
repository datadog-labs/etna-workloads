Reproducer (repro.sql): two FTS4 tables, both written inside BEGIN + SAVEPOINT, then ROLLBACK TO.
With the bug, the second vtab's xSavepoint gets called twice for the same savepoint level, so
FTS3's `assert(pTab->mxSavepoint<iSavepoint)` fails (abort, exit -6). The clean shell runs silently with exit 0.
