# Rationale

File/function: src/backend/commands/tablecmds.c, `PartConstraintImpliedByRelConstraint`.

Traces to the fix.patch hunks in `ATExecAttachPartition` that removed the `not_null_attrs` / `partition_accepts_null` workaround. The code has since moved: the check now lives in `PartConstraintImpliedByRelConstraint`, and predtest uses a `weak` flag instead of `clause_is_check`. The reverted logic is re-added there. It records which columns have a column-level NOT NULL. If the proof succeeds but the partition constraint contains a `key IS NOT NULL` test on a column without a NOT NULL property, it refuses to skip validation. Before the fix, predtest did not understand CHECK clauses, so this guard was needed. It has the same effect as before: a CHECK (a IS NOT NULL AND a = 5) does not allow the scan to be skipped, and the INFO "implied by existing constraints" message is not emitted.

The predtest.c changes are untouched, because the current weak-implication code is the part of the fix that remains correct. Only the guard that the fix made unnecessary is restored.

Failing oracle case: src/test/regress||alter_table
