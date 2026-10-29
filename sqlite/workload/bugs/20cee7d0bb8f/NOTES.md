repro.sql inserts into tables whose CHECK constraints call date()/julianday() with 'now'.
Clean shell: "non-deterministic use of date()/julianday() in a CHECK constraint" errors.
Buggy shell: the function is evaluated as if deterministic, so it gives
"CHECK constraint failed: ..." for lines 2 and 5 and silently accepts the insert on line 4.
