# Rationale

Reverse of fix.patch: the stats functions go back to "look up OID by name, then lock, then check privileges" instead of using RangeVarGetRelidExtended() with a permission callback.

- `src/backend/statistics/stat_utils.c`: `RangeVarCallbackForStats()` is replaced by `stats_lock_check_privileges()` and `stats_lookup_relid()` (stat_utils.c hunks of fix_impl.patch). The old code locks the relation before checking privileges, so users can briefly lock relations they have no rights on. It also doesn't verify that the locked relation matches the name that was looked up. Indexes are locked with AccessShareLock rather than ShareUpdateExclusiveLock.
- `src/include/statistics/stat_utils.h`: declarations swapped back (stat_utils.h hunk).
- `src/backend/statistics/attribute_stats.c` (`attribute_statistics_update`, `pg_clear_attribute_stats`) and `relation_stats.c` (`relation_statistics_update`): calls to RangeVarGetRelidExtended() are replaced by `stats_lookup_relid()` followed by `stats_lock_check_privileges()`. The `locked_table` variables are removed (matching hunks of fix_impl.patch).

Failing oracle case: `src/test/regress||stats_import`
