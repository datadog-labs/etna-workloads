# Re-introduced bug

**File/function:** src/backend/commands/tablecmds.c, `DetachPartitionFinalize`

**Traces to:** the fix.patch hunk in `DetachPartitionFinalize` that replaced the simple
`createForeignKeyActionTriggers()` call with a block that deconstructs the FK row and calls
`addFkRecurseReferenced()`. That block recurses and creates pg_constraint rows and action triggers
for each partition of the referenced table.

**Change:** the recursive block is reverted to the pre-fix code. It builds a synthetic Constraint
and calls `createForeignKeyActionTriggers()` once, on the referenced table only.

**Why this brings the bug back:** when the referenced table is partitioned, detaching a referencing
partition creates action triggers only on the top-level referenced table. The per-partition
pg_constraint rows and action triggers are never created. UPDATE or DELETE on the referenced
partitions then fails to enforce the FK against rows in the detached table. The other fix hunks
(addFkConstraint refactor, and the cleanup in tryAttachPartitionForeignKey) are not reverted.
This is a minimal re-expression of the bug.

**Oracle case expected to fail:** src/test/regress||foreign_key
