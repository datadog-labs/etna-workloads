Reproducer (repro.sql): enables the shell authorizer (`.auth ON`) and runs a SELECT over a
subquery (`SELECT * FROM sqlite_master UNION ALL SELECT * FROM temp.sqlite_master`), as in auth-5.2 (ticket #1607).
Clean shell: prints authorizer calls and the result `t1`, exit 0.
Buggy shell: the missing `iDb<0` check in sqlite3AuthRead makes it index db->aDb with a negative
index for subquery columns, so it crashes (SIGSEGV, exit -11) with no output.
