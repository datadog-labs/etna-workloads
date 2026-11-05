# Rationale

File: src/bin/scripts/vacuumdb.c, function vacuum_one_database() (catalog query construction). Two hunks, both from the single fix_impl.patch hunk pair:

1. JOIN clause: LEFT JOIN listed_objects ON object_oid = ... is changed back to an inner JOIN, using `!=` when OBJFILTER_SCHEMA_EXCLUDE is set (fix hunk 1).
2. The "WHERE listed_objects.object_oid IS [NOT] NULL" filter block is removed (fix hunks 1 and 2). In the current code it was written as " AND ..." after the temp-table WHERE, not via has_where.

Why this is the bug: with several -N schemas, the inner join on `object_oid != ns.oid` matches each table once per excluded schema that is not its own. A table in an excluded schema still joins to the other excluded schemas, so it is not excluded. Tables in other schemas are returned several times.

Failing oracle case:
- src/bin/scripts|t/100_vacuumdb.pl|vacuumdb multiple --exclude-schema switches: SQL found in server log
