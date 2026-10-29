Reproducer for the missing replace-trigger recheck (insert-16.x). With recursive_triggers on,
an AFTER DELETE trigger re-inserts the conflicting row during REPLACE.
Clean: "UNIQUE constraint failed: t0.c0", table keeps (123,1), integrity ok.
Buggy: the uniqueness recheck is skipped, so the REPLACE succeeds, leaving a wrong table
and/or an index inconsistent with it (see check.sh output).
