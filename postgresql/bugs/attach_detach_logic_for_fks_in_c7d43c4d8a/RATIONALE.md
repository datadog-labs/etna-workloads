# Reintroduced bug

File/function: src/backend/commands/tablecmds.c, DetachPartitionFinalize (the former ATExecDetachPartition "Detach foreign keys" loop).

Traces to the fix_impl.patch hunk in ATExecDetachPartition adding the "Detach foreign keys" loop, whose key call is `ConstraintSetParentConstraint(fk->conoid, InvalidOid)`.
That call (and the matching InvalidOid branch in pg_constraint.c) is what clears conparentid/coninhcount/conislocal and the internal-auto dependency on detach. I removed that call, so a detached partition's FK constraint stays marked as a child of the parent's constraint. The check triggers are still detached from their parents, so the catalog is inconsistent.

Failing oracle cases:
- src/test/regress||foreign_key
