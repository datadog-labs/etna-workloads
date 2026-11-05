# Rationale
Hunk: src/backend/commands/tablecmds.c, find_composite_type_dependencies (traces to the tablecmds.c hunks of fix_impl.patch).
Removed the recursion into directly dependent types (pg_depend classid == TypeRelationId: arrays, domains, ranges), and restored the old special case that only checks the array type of the rowtype via get_array_type. Domains/ranges over a composite type (and arrays of a domain, etc.) are no longer checked, so ALTER TYPE / ALTER TABLE and domain constraint addition miss stored columns of container types.
(The typecmds.c hunk was left alone; its call into find_composite_type_dependencies now does not recurse.)
Failing oracle case: src/test/regress||domain
