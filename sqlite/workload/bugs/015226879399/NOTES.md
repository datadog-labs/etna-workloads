repro.sql creates a trigger on `T1` (different case from table `t1`), then renames `t1` to `pqr3`, inserts into it and selects from the log table.

- Clean: the rename updates the trigger, and the output is `789`, exit 0.
- Buggy: the rename's `tbl_name=%Q` match is case-sensitive, so the trigger is skipped. The shell prints "error in trigger r1 after rename" and then "no such table: pqr3", and exits 1.
