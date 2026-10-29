repro.sql turns on the shell authorizer trace (`.auth ON`) and runs `INSERT INTO t2 SELECT * FROM t1;`.
Clean shell: the authorizer is called for SELECT and READ t1.a/b/c, because the xfer optimization checks the source table.
Buggy shell: the xfer optimization skips those checks, so only the INSERT authorizer line is printed.
This is the same bug as auth2-3.1; the SQLITE_IGNORE case (auth2-3.2) isn't covered.
