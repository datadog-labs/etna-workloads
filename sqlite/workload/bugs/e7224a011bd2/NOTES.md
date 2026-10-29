Reproducer: repro.sql. Copies a row with a conflicting key from t2 to t1 via INSERT INTO ... SELECT. Both tables have INTEGER PRIMARY KEY ON CONFLICT IGNORE.
Clean shell prints `1|2` because the conflict is ignored. The buggy shell uses the xfer optimization with plain ABORT semantics and fails with a UNIQUE constraint error. This is insert4-8.3.
