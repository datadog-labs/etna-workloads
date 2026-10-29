Reproducer: `repro.sql` (the SQL from index6-17.1/17.2).

A partial index i0 (`WHERE c0 GLOB c0`) is followed by unique indexes on a constant expression. With the bug, sqlite3GenerateIndexKey reuses column registers from the prior index after the partial-index WHERE test may have clobbered them.

Clean shell: both integrity_checks print `ok`, exit 0.
Buggy shell: integrity_check reports "row 1 missing from index i0", and REPLACE fails with "database disk image is malformed" (exit 1).
