# Rationale

File: src/backend/utils/adt/acl.c

1. `convert_column_name()` — traces to the fix.patch hunk that rewrites it. It is
   restored to the old version: `get_attnum()` followed by an ERROR whenever the
   column isn't found. That makes a dropped column, or a nonexistent or just-dropped
   table OID, throw "column ... does not exist" instead of returning NULL.
   `get_rel_name()` can also return NULL here.
2. `column_privilege_check()` — traces to the hunk that adds the early
   `if (attnum == InvalidAttrNumber) return -1;`. That check is removed. It is
   dead code once hunk 1 is reverted.

I did not revert the comment hunks or the FDW, server and tablespace `SearchSysCacheExists1` hunks.
The `has_column_privilege` NULL-return behavior is enough to reproduce the bug.

Failing oracle case: src/test/regress||privileges
