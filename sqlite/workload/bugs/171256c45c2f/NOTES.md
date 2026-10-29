Reproducer: DELETE with a multi-index OR clause (`b IS NULL OR c IS NULL`, both columns indexed).
With the bug, the OR-optimization loop leaves pLevel->op unset for DELETE/UPDATE
(WHERE_DUPLICATES_OK), so the buggy shell aborts with assertion
`pLevel->op==OP_Return` in sqlite3WhereCodeOneLoopStart (exit -6). The clean shell
deletes the rows and prints `3`.
