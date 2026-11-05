# Rationale

File: src/backend/utils/adt/ruleutils.c, function set_deparse_for_query()
Traces to the single fix_impl.patch hunk. I removed the `if (query->jointree)` guard
("If it's a utility query, it won't have a jointree") around the has_dangerous_join_using()
and set_using_names() calls. A NOTIFY rule action is a utility Query with a NULL jointree,
so deparsing it (e.g. pg_get_ruledef) dereferences NULL and crashes.

Oracle case expected to fail: src/test/regress||rules
