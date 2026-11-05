# Rationale

File: src/backend/utils/adt/partitionfuncs.c

1. `check_rel_can_be_partition()` - traces to the first fix_impl hunk. The fix replaced the relkind allow-list (plain relation, foreign table, index, partitioned table/index) with "relispartition or partitioned table/index". I restored the old check, so any plain table, foreign table or index passes, even if it is not part of a partition tree. The `relispartition` variable and lookup are removed again.
2. `pg_partition_root()` - traces to the second hunk. I restored the early `if (!get_rel_relispartition(relid)) PG_RETURN_OID(relid);`. The partition functions now return the relation itself for standalone tables, instead of NULL / an empty result.

Oracle case expected to fail: src/test/regress||partition_info
