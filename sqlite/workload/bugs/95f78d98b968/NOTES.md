`repro.sql` is the alter-17.100 case: an rtree virtual table, a trigger on t1 that deletes from it, then `ALTER TABLE t1 RENAME TO t3` and an UPDATE that fires the trigger.

- clean: exit 0, prints `1|1.0|2.0` and `3|1.5|3.5`.
- buggy: aborts with `selectExpander: Assertion '0' failed` (exit -6).

The injected change skips `sqlite3ViewGetColumnNames()` for virtual tables during a rename. Their columns are then never loaded.
