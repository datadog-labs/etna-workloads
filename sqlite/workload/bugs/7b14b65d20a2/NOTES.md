Reproducer (repro.sql) is test update-20.x: a table with a UNIQUE ON CONFLICT REPLACE column, an index, and a DELETE trigger that UPDATEs the same table (recursive_triggers on). `UPDATE t1 SET a=0` triggers REPLACE deletion, which fires the trigger.

Clean: the UPDATE fails with "constraint failed", the table is unchanged, integrity_check is ok.
Buggy: the UPDATE succeeds, integrity_check reports "row 1 missing from index i0", and the table holds only `0|13`.
