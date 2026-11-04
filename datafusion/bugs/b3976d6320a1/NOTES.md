`repro.sql` creates t1/t2/t3 and runs `UPDATE ... FROM t2` plus an UPDATE with two FROM tables.

Clean build: `UPDATE ... FROM` fails with "This feature is not implemented: UPDATE ... FROM is not supported". The multi-table form fails with a "not implemented" error.
Buggy build: the single-table `UPDATE ... FROM` runs and returns count 0, with the wrong semantics. The multi-table form fails with "Error during planning" instead of "not implemented".
