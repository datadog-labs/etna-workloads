repro.sql builds a schema inside a transaction, runs `PRAGMA schema_version=0` and `PRAGMA writable_schema=RESET`, then rolls back. The in-memory schema keeps p1 and p1's autoindex, but the file has no such tables. `.dbconfig defensive off` is needed because the shell enables defensive mode, which blocks the schema_version write.

`PRAGMA integrity_check` then runs against this corrupt database.
- clean: prints "wrong # of entries in index sqlite_autoindex_p1_1" and exits with status 1.
- buggy: aborts with `Assertion memIsValid(&aMem[pOp->p1]) failed` in sqlite3VdbeExec (exit -6). The injection removes the OP_Null that initializes the integrity_check registers.
