# Rationale

Reverts fix 23cccb17fe0b (dropped columns in a default partition) by removing the attno mapping of the default-partition constraint.

## src/backend/commands/tablecmds.c, ATExecAttachPartition
Traces to the tablecmds.c hunk of fix.patch. Removed the `map_partition_varattnos(defPartConstraint, 1, defaultrel, rel)` call. The constraint is queued for validation on the default partition in the parent's attnos. If the default partition has dropped columns, the Vars point at the wrong columns.

## src/backend/partitioning/partbounds.c, check_default_partition_contents
Traces to the three partbounds.c hunks of fix.patch.
- Removed the up-front mapping of `def_part_constraints` from parent to default_rel.
- Removed the per-subpartition mapping from default_rel to part_rel, and the `partition_constraint` assignments in both branches.
- Restored the old code that sets `constr = linitial(def_part_constraints)` and maps it from parent to part_rel just before scanning, and restored the `Expr *constr` declaration.

The up-front mapping is gone, so the implication test `PartConstraintImpliedByRelConstraint` also runs on an unmapped constraint. With dropped columns, the constraint is evaluated against the wrong attnos.

## Failing oracle cases
- src/regress||alter_table
