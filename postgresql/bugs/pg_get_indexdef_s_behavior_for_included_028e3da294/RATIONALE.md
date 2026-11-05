# Rationale

Both hunks are in `src/src/backend/utils/adt/ruleutils.c`, function `pg_get_indexdef_worker`. They trace to the fix_impl.patch hunk that replaced the `attrsOnly` conditions with `keysOnly` and `!colno`.

1. Loop start: `if (keysOnly && keyno >= indnkeyatts) break;` is back to `if (attrsOnly && ...)`. When `pg_get_indexdef(oid, colno, ...)` is called with a nonzero colno, attrsOnly is true. The loop then stops at the first INCLUDE column, so included columns are not reported.
2. INCLUDE divider: `if (!colno && keyno == indnkeyatts)` is back to `if (!attrsOnly && ...)`. The divider is now keyed on attrsOnly instead of colno.

The `keysOnly` parameter is still passed around but no longer used. The callers are unchanged, because the bug lives in the worker's conditions.

Failing oracle case: src/test/regress||index_including
