# Rationale
File: src/backend/commands/tablecmds.c, function DetachPartitionFinalize (the current home of the code from ATExecDetachPartition in fix.patch).

Hunk: in the loop that detaches partition indexes, I removed the lookup of the index's constraint
(`get_relation_idx_constraint_oid`) and the `ConstraintSetParentConstraint(constrOid, InvalidOid, InvalidOid)` call,
along with the now-unused local variables. This traces to the fix hunk that added "Detach any constraints
associated with the index too". Without it, detaching a partition leaves the UNIQUE/PRIMARY KEY
constraints of the partition still marked as inherited (conparentid/coninhcount set), so they
stay attached to the former parent's constraints.

Failing oracle case: src/test/regress||indexing (see the oracle output).
