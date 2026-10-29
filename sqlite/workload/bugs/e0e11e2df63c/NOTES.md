The injected bug makes sqlite3_exec() add the previous statement's change count
into db->nChange when starting the next statement of a multi-statement string.
The shell has no plain way to call sqlite3_exec on multiple statements, but
`.selftest --init` does (createSelftestTable): a series of INSERTs followed by
DROP TABLE. repro.sql runs it and then prints `SELECT changes();`.
Clean prints 3 (rows of the last INSERT); buggy prints 6 (double counted).
