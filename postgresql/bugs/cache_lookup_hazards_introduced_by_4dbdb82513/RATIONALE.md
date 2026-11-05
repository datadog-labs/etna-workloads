# Rationale
The fix (4dbdb82513b6) removed the partition-ancestor privilege shortcut (`has_partition_ancestor_privs`) from the MAINTAIN checks, because it did catalog lookups on ancestors that were hazardous in these callbacks. I restored it in the places the fix touched.

- tablecmds.c `has_partition_ancestor_privs` (new function) and `RangeVarCallbackMaintainsTable`: reverse of the tablecmds.c hunks. The callback now accepts ancestor privileges.
- include/commands/tablecmds.h: declaration restored (header hunk).
- vacuum.c `vacuum_is_permitted_for_relation`: reverse of the vacuum.c hunk. Include restored.
- cluster.c `cluster_is_permitted_for_relation`: reverse of the cluster.c hunk. The per-partition check in `get_tables_to_cluster_partitioned` was already present in current code, so I left it alone.
- lockcmds.c `LockTableAclCheck`: reverse of the lockcmds.c hunk. Include restored.
- indexcmds.c `RangeVarCallbackForReindexIndex` and `ReindexMultipleTables`: reverse of the indexcmds.c hunks. The existing `aclresult` structure is kept.

Failing oracle cases: isolation cluster-conflict-partition, regress cluster, regress vacuum.
