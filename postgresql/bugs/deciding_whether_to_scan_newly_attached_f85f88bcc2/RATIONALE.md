# Rationale

## src/backend/commands/tablecmds.c, ATExecAttachPartition()
Traces to fix.patch hunk "Adjust the generated constraint to match this partition's
attribute numbers" (the added `map_partition_varattnos(partConstraint, 1, attachrel, rel, ...)`
call placed before the decision on whether to scan the attached table).

In today's code that call sits just before QueuePartitionConstraintValidation(), which
runs the implication test (PartConstraintImpliedByRelConstraint) on the constraint. I removed
it. The constraint therefore keeps the parent's attribute numbers when it is tested against
the attached table's own constraints. If the attached table has different attnos (dropped
columns, different column order), the skip-scan decision is wrong. The unmapped constraint
is also what gets queued for the scan.

The other fix hunks (per-partition remapping in the old loop) are already handled by
QueuePartitionConstraintValidation's recursion in current code, so I left them alone.

## Failing oracle cases
- src/test/regress||alter_table
