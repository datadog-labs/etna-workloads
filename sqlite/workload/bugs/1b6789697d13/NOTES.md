repro.sql creates a table whose PRIMARY KEY lists column a twice, then runs PRAGMA table_info on it.
- clean: prints the three rows, with pk values 1, 2 and 4.
- buggy: the ALWAYS(k<=nCol) loop bound is reached, so the shell aborts on assertion `0` in sqlite3Pragma (exit -6).
