# Rationale

The fix (2019-10-16) added, after a REPLACE-driven row delete that may fire
AFTER DELETE triggers/FK actions, a recheck (OP_NotExists + RowidConstraint for
the rowid, OP_NoConflict + UniqueConstraint for indexes) that the conflict was
really resolved. In 3.54.1 this was reimplemented as a deferred recheck pass:
`nReplaceTrig` counts the replace deletes coded, and if nonzero, the end of
sqlite3GenerateConstraintChecks() emits the `OP_IfNot regTrigCnt` + recheck jump
(rowid: OP_NotExists/sqlite3RowidConstraint; indexes: copied OP_NoConflict blocks
+ sqlite3UniqueConstraint).

Change (src/insert.c): removed both `nReplaceTrig++` statements (IPK REPLACE
branch and index REPLACE branch). nReplaceTrig stays 0, so the recheck pass is
never entered, which restores the pre-fix behaviour: no verification after the
delete triggers run, so a trigger that re-inserts the conflicting row yields
duplicate/inconsistent index entries instead of a UNIQUE constraint failure.
This reverses the fix hunks for both the rowid path and the index (`default:`) path.
MultiWrite calls are kept, as in the pre-fix code.

Failing oracle cases (test/insert.test): insert-16.1..16.7 (expected UNIQUE
constraint failed; now succeeds / integrity_check reports non-unique index
entries), plus insert-17.1-17.4, 17.14, 17.15 (later related recheck tests).
