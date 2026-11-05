# Rationale
File: src/backend/utils/adt/ruleutils.c, functions get_insert_query_def, get_update_query_def, get_delete_query_def.
Trace: the fix.patch hunks that replace the `rte->alias` printing with `get_rte_alias(...)` in INSERT/UPDATE/DELETE.
The reverse prints the target alias only when the user wrote one (rte->alias), using the raw alias name. It ignores the name chosen by set_rtable_names (e.g. when it had to resolve a conflict) and ignores the column-alias-needed case, so the deparsed DML target alias is wrong or missing. The helper get_rte_alias is kept and still used by FROM items and MERGE.

Failing oracle case: src/test/regress||rules
