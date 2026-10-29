repro.sql runs the update-19.10 case: an UPDATE on a table with a UNIQUE INTEGER PRIMARY KEY, where the new value (`quote(b)`) reads only the rowid, so no OP_Column runs after the OP_DeferredSeek.

Clean shell: prints `2|2`, exit 0.
Buggy shell: aborts with the assertion `pC->deferredMoveto==0` in OP_Insert (exit -6), because the OP_FinishSeek is missing.
