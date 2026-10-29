repro.sql is test indexexpr2-11.0: a table with an indexed generated column used inside an aggregate in a correlated subquery over the same table as the outer query.

Clean shell: prints `44|-44`, exit 0.
Buggy shell: `Parse error near line 4: internal query planner error (2)`, exit 1. The injection removes the check that the indexed expression belongs to the current aggregate's source list, so nested aggregates resolve to the wrong one.
