Inserts into an FTS5 virtual table from a SELECT (`INSERT INTO t(a,b,c) SELECT * FROM d`), which the test does with the echo module (not available in the shell).
Clean shell inserts the rows and prints them. Buggy shell computes the coroutine's output register one slot off for virtual tables, so it aborts with assertion `memIsValid(pX)` in sqlite3VdbeExec (exit -6).
