# Rationale

Reverse of fix.patch re-applied to current code.

1. src/backend/commands/tablecmds.c, ATPrepCmd (AT_SetOptions/AT_ResetOptions): re-added `ATT_INDEX` to ATSimplePermissions (fix hunk in tablecmds.c). ALTER INDEX ... ALTER COLUMN SET (options) is accepted again.
2. src/backend/commands/analyze.c, compute_index_stats: restored the get_attribute_options() lookup and the n_distinct override of stats->stadistinct (fix hunks in analyze.c). Uses `onerel->rd_id`/`stats->tupattnum` since VacAttrStats no longer has `attr`.

Failing oracle case: src/test/regress||btree_index
