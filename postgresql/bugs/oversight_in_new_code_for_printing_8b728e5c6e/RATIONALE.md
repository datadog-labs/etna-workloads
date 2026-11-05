# Rationale

File: src/backend/utils/adt/ruleutils.c, function get_rte_alias (the code that fix.patch changed in get_from_clause_item has since moved here).

Traces to the fix_impl.patch hunk that added the `else if (rte->rtekind == RTE_CTE)` branch. That branch sets printalias when the deparsed refname differs from the CTE name. I removed it. A CTE reference that set_rtable_names renamed to resolve a conflict, and that has no user alias, now prints without the alias. The deparsed query then refers to the wrong name or becomes ambiguous.

Failing oracle case: src/test/regress||with
