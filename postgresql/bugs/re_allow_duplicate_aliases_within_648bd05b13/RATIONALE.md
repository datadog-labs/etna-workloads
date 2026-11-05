# Rationale

Changed hunk: `src/backend/parser/parse_clause.c`, `transformFromClauseItem()` (JOIN branch).

Traces to the `parse_clause.c` hunk of fix_impl.patch, which removed the
`checkNameSpaceConflicts(pstate, pstate->p_namespace, l_namespace)` call before the
left-side namespace is pushed for processing the RHS. I re-added that call, so
duplicate aliases hidden inside an aliased JOIN (e.g. `tab1 x CROSS JOIN (tab2 x CROSS JOIN tab3 y) z`
with a LATERAL RHS) are again rejected with "table name specified more than once".

The parse_relation.c hunks of the fix were comment-only, so nothing needed to change there.

Failing oracle case: src/test/regress||join
