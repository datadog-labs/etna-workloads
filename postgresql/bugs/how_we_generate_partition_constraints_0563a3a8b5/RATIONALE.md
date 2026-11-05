# Rationale

Fix: partition quals must be mapped to the partition's attnos after concatenating the parent's quals, and the attach path maps the constraint to each sub-partition's attnos.

1. `src/backend/utils/cache/partcache.c`, `generate_partition_qual()` (fix.patch hunk in `generate_partition_qual` / `map_partition_varattnos`): attno mapping is applied only to this relation's own `my_qual` (parent attnos -> rel attnos) before `list_concat` with the parent's qual. The parent's quals therefore keep the parent's attnos in a multi-level tree with differing physical attnos, and that wrong result is cached in `rd_partcheck`.
2. `src/backend/commands/tablecmds.c`, `QueuePartitionConstraintValidation()` (fix.patch hunk in `ATExecAttachPartition` that calls `map_partition_varattnos` for sub-partitions): the per-partition remap is removed (`thisPartConstraint = partConstraint`), so the validation scan of sub-partitions uses the parent's attnos.

Failing oracle case: `src/test/regress||alter_table` (the multi-level `p/p1/p11` test; other tests like insert and triggers also diverge).
