# Rationale

File: src/backend/commands/tablecmds.c (both hunks trace to fix_impl.patch)

1. `ATExecAttachPartition`: removed the block that, when the attached table is partitioned, calls
   `CacheInvalidateRelcacheByRelid` for every entry of `attachrel_children`. Descendant partitions
   then keep stale `rd_partcheck` trees after ATTACH.
2. `DetachPartitionFinalize`: removed the block that, when the detached partition is partitioned,
   locks all descendants with `find_all_inheritors` and invalidates their relcache entries. Stale
   `rd_partcheck` remains after DETACH.

Failing oracle case: src/test/regress||alter_table
