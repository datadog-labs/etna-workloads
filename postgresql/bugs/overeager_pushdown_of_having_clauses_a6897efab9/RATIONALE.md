# Rationale

File: src/backend/optimizer/plan/planner.c, function subquery_planner.

Traces to the fix.patch hunk that adds `(parse->groupClause && parse->groupingSets) ||` to the HAVING-to-WHERE pushdown test. In current code that check is the clause `parse->groupClause && parse->groupingSets && bms_is_member(root->group_rtindex, pull_varnos(...))`. I removed it. HAVING clauses that reference columns nulled by grouping sets are now moved or copied into WHERE again. This filters rows before grouping, so results are wrong when a referenced column is missing from some grouping sets.

Failing oracle case: src/test/regress||groupingsets
