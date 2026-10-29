repro.sql is the test case from tkt3832 translated to SQL. It uses a BEFORE INSERT trigger on a table with an INTEGER PRIMARY KEY. It then runs `INSERT INTO t1 SELECT b, a FROM t1`, which inserts a NULL into the INTEGER PRIMARY KEY.

Clean shell: the insert succeeds. The NULL rowid is replaced with -1 for the trigger's `new.b`, and the final SELECTs return 4 rows.
Buggy shell: the NULL-to-`-1` substitution is skipped on the SELECT path. The insert fails with "datatype mismatch", and the last rows are missing from the output.
