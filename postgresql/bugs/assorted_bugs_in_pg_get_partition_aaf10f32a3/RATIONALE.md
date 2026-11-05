# Rationale

All changes are in `src/backend/utils/cache/partcache.c`. The `lsyscache.c` and `lsyscache.h` hunks of fix.patch are left in place. `get_rel_relispartition` stays defined but is no longer called.

1. `get_partition_qual_relid()` traces to the fix.patch partcache.c hunk of the same name.
   It now opens the relation unconditionally with `relation_open()` and only afterwards checks `rd_rel->relispartition`. The fix instead tested `get_rel_relispartition(relid)` first and opened the relation only if that was true.
   The bug is back for any OID: a nonexistent OID makes `pg_get_partition_constraintdef()` raise "could not open relation with OID" instead of returning NULL.
   The relation is also locked, and its relcache entry built, even when it is not a partition.

2. `generate_partition_qual()` traces to the fix.patch hunk that handled a null `relpartbound`.
   A null `relpartbound` raises `elog(ERROR, "null relpartbound ...")` again. The fix tolerated it and treated the partition's own qual as empty.
   This also restores the function-level `bound` variable.

## Failing oracle cases
- src/test/regress||indexing
