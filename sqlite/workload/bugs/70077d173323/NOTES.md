Reproducer (repro.sql): the intpkey-17.0 case. A table with an INTEGER PRIMARY KEY and an index on that column, then `DELETE ... WHERE x=99 OR x<130`.
Clean shell: prints `248|giraffe`, exit 0.
Buggy shell: assertion failure `pC->deferredMoveto==0` in sqlite3VdbeExec (exit 134), because the OR-clause subloop's deferred seek isn't propagated to the outer WhereInfo.
