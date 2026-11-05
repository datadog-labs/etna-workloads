# Rationale

File: src/backend/utils/adt/ruleutils.c

1. `set_relation_column_names()` — traces to the hunk that makes RTE_FUNCTION use expandRTE(..., include dropped) instead of rte->eref->colnames. Reverted to always use `rte->eref->colnames`, so columns dropped from a composite type after parse are not detected (stale names are shown instead of NULL).
2. `get_variable()` — traces to the hunk replacing the elog(ERROR) with `attname = "?dropped?column?"`. Restored the error for a NULL attname, so a Var referencing a dropped column fails with "invalid attnum".

The comment-only hunks (parse_relation.c and the header include) are not reproduced.

Failing oracle case: src/test/regress||create_view
