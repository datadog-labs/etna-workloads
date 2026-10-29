`repro.sql` runs `EXPLAIN DROP TABLE` on an AUTOINCREMENT table. The shell has no
pre-update hook command, and the session extension ignores the schema tables
(they have no PK), so the hook can't be observed directly. The fix's effect shows
in the bytecode instead.

The nested-parse `OP_Delete` ops that remove rows from sqlite_sequence and
sqlite_master should carry no P4_TABLE argument. That argument is what makes
the VDBE fire the pre-update hook.

- clean: the P4 column of those two Delete rows is empty.
- buggy: it shows `sqlite_sequence` and `sqlite_master`, so DROP TABLE would
  invoke the pre-update hook for schema changes.
