repro.sql creates a child table k1 referencing a nonexistent parent table s1 and
runs PRAGMA foreign_key_check(k1).

Clean: a missing parent is treated as empty, so the check succeeds and reports
the orphan row (`k1|1|s1|0`).
Buggy: the pragma fails with "no such table: main.s1" (exit status 1).
