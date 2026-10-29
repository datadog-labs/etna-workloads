Reproducer: repro.sql (the fkey1-9.1 case). It enables foreign keys and creates a parent table and a child table whose names contain double quotes. The child has `REFERENCES ... ON DELETE RESTRICT`. It then runs DELETE on the parent.

Clean shell: prints `done`, exit 0.
Buggy shell: the RESTRICT trigger de-quotes the table name a second time, so `sqlite3Dequote` hits `Assertion 'z[i]' failed` and the shell aborts with exit 134.
