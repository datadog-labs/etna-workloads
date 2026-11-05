# Rationale

File: src/backend/utils/adt/ruleutils.c, function pg_get_statisticsobj_worker (successor of pg_get_statisticsext_worker).

Traces to both fix_impl.patch hunks (the other hunk removed the pg_class lookup, which no longer exists in this code):
- CREATE STATISTICS name: the fix uses quote_qualified_identifier(nsp, name); reverted to quote_identifier(name), so the schema is dropped (removed the unused `nsp` variable).
- FROM clause: the fix uses generate_relation_name(); reverted to quote_identifier(get_rel_name(relid)), so the table's schema is dropped.

Result: pg_get_statisticsobjdef output is not schema-qualified, which is wrong when objects are outside the search path.

Failing oracle case: src/test/regress||stats_ext (rules still passes).
