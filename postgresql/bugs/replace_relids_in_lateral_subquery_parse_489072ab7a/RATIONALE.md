# Rationale

File: src/backend/optimizer/plan/analyzejoins.c, function replace_relid_callback (used by SJE's ChangeVarNodesExtended on root->parse).

Traces to the fix.patch hunk in remove_rel_from_query that added
`query_tree_walker(rte->subquery, replace_varno_walker, ...)` so relids get replaced
inside lateral subquery parse trees. In today's code that replacement happens through
the generic ChangeVarNodes walk descending into rtable subqueries (the explicit walk was
refactored away). To bring the bug back, the callback now stops descent into subquery
Query nodes at the top level, so relids of the removed rel are not replaced in lateral
subquery parse trees; they keep referencing the eliminated relid.

Failing oracle case: src/test/regress||join
