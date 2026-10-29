# Rationale

Fix: after an UPDATE OR REPLACE whose DELETE trigger removed the row being
updated, the UPDATE must not go on (the fix moved the OP_NotFound/OP_NotExists
reseek to right after GenerateConstraintChecks and made it jump to
labelContinue).

## Hunks changed

1. `src/update.c` (the fix's only implementation hunk, reversed): the reseek
   after `sqlite3GenerateConstraintChecks()` is removed. As before the fix, it
   is emitted just before `sqlite3GenerateRowIndexDelete()` (after the FK
   check) with jump target 0 (`addr1`), and `sqlite3VdbeJumpHere(v, addr1)`
   is placed after the OP_Delete block. If the row is gone, only the old-index
   and old-row deletion are skipped, and the new row/index entries are still
   inserted.

2. `src/insert.c` `sqlite3GenerateConstraintChecks()`: 3.54.1 also covers this
   case from a second path, the "recheck all uniqueness constraints after
   replace triggers have run" logic (regTrigCnt / lblRecheckOk / nReplaceTrig).
   It turns the situation into SQLITE_CONSTRAINT, which masks the update.c
   defect (the tree's conflict3.test 13.x expects "constraint failed"). That is
   the same defect (UPDATE proceeding after a DELETE trigger changed the table
   during REPLACE), so I disabled it by forcing the "no DELETE triggers / no FK"
   branch (`if( 1 || ... )`), i.e. regTrigCnt=0 and pTrigger=0 as in the
   2019-08 code, which had no recheck.

## Oracle failures

conflict3-13.1.1, 13.1.3, 13.2.1, 13.2.3: the tree's tests expect
`{1 {constraint failed}}` and unchanged tables. Now the UPDATE succeeds, and
the deleted row is re-inserted (13.1.3 / 13.2.3 return wrong rows, e.g.
`2 2 0`) instead of leaving the table as before.
