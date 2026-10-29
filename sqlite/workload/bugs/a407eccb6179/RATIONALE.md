# Rationale

Fix: after replace triggers fire during uniqueness checking, all uniqueness
checks are rerun with ABORT semantics. The rerun is only taken when the
`regTrigCnt` counter is positive, so the bug is restored by never incrementing it.

## Changes (src/insert.c, sqlite3GenerateConstraintChecks)

1. Removed `sqlite3VdbeAddOp2(v, OP_AddImm, regTrigCnt, 1)` in the IPK REPLACE
   branch. Reverses the fix hunk that added the "incr trigger cnt" there (the
   old code instead did an OP_NotExists/rowid-constraint check right after the delete).
2. Removed the same `OP_AddImm` after `sqlite3GenerateRowDelete()` in the
   UNIQUE-index REPLACE branch. Reverses the hunk that added it (the old code
   did only a single inline OP_NoConflict retry).

The counter stays 0, so the final `OP_IfNot regTrigCnt` always jumps past the
recheck block. A replace trigger that inserts a conflicting row is no longer detected.

## Oracle failures

test/insert.test: insert-17.1, 17.2, 17.3, 17.4, 17.14, 17.15 (expected UNIQUE
constraint failed, got success / corrupt index) and insert-16.1-16.7 (index
integrity / constraint errors).
