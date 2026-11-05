# Rationale

Changed hunk: src/backend/optimizer/plan/subselect.c, simplify_EXISTS_query().

Traces to the fix.patch hunk that adds removal of the RTE_GROUP RTE (today expressed as converting it to RTE_RESULT in place and clearing hasGroupRTE) after groupClause is thrown away. I deleted that block. The groupClause is again dropped while the RTE_GROUP RTE and hasGroupRTE flag stay. The planner then sees a query with a group RTE but no grouping, which gives wrong behavior or errors for EXISTS subqueries with GROUP BY.

Failing oracle case: src/test/regress||join (see oracle output).
