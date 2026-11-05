# Rationale
Hunks (fix.patch -> reversed):
1. src/backend/replication/logical/relation.c, logicalrep_partition_open(): the fix replaced `entry->updatable = root->updatable;` with `logicalrep_rel_mark_updatable(entry)`. Restored the copy from the root, so a partition inherits the root's updatable flag instead of checking its own replica identity/PK.
2. src/backend/replication/logical/worker.c, check_relation_updatable(): removed the early return for RELKIND_PARTITIONED_TABLE (fix hunk adding it). Updates/deletes on a partitioned target without a matching RI/PK on the root now raise an error or are judged on the root's flag.

(The logicalrep_rel_mark_updatable helper was kept; only its use in the partition path was reverted, a minimal change.)

Failing oracle case:
- src/test/subscription|t/013_partition.pl|updates of tab5 replicated correctly#2
