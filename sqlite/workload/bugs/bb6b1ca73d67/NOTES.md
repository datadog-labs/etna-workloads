Reproducer: table with `INTEGER PRIMARY KEY ON CONFLICT REPLACE` plus a UNIQUE column, then `UPDATE t16 SET a=a`.
With the bug, the "rowid unchanged" skip is emitted after the REPLACE conflict logic, so the update
deletes/mangles rows (or asserts); the clean shell returns all three rows 1|2, 3|4, 5|6.
