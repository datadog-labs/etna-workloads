Reproducer (repro.sql): a REPLACE INTO whose conflicting row is deleted fires an AFTER DELETE trigger
that re-inserts the conflicting row (recursive_triggers on). Clean: the statement fails with
"UNIQUE constraint failed: t0.c0" and the table is unchanged. Buggy: the retry check is missing, so the
statement proceeds and leaves a wrong table/index state (see check.sh output).
