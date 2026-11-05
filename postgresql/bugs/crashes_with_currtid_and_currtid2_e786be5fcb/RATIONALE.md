# Rationale

File: src/backend/utils/adt/tid.c, function `currtid_internal` (the current code merged the former currtid_byreloid/currtid_byrelname checks into this helper).

Traces to the fix_impl.patch hunks that add the `!RELKIND_HAS_STORAGE` error check in currtid_byreloid and currtid_byrelname. I removed that check. Relations without storage (e.g. partitioned tables, foreign tables, sequences' siblings like partitioned indexes) now reach `table_beginscan_tid`/`table_tuple_get_latest_tid` and crash instead of raising a clean error. The `lsyscache.h` include is left in place because other code in the file still uses it.

Failing oracle case: src/test/regress||tid
