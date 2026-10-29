Reproducer: `repro.sql` is autoinc-11.1 (UPSERT into an AUTOINCREMENT table).

Clean shell prints `5`. The buggy shell, which calls sqlite3AutoincrementEnd() from the UPSERT's UPDATE code, aborts with `Assertion 'pC!=0' failed` in sqlite3VdbeExec (exit status -6).
