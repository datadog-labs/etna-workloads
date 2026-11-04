repro.sql creates a small table and runs `age = ANY (SELECT age ...)` and `age <> ALL (SELECT age ...)` against itself (the statements from the fix's subquery.slt test).

Clean build: returns rows 1,2,3 for the first query and an empty result for the second.
Buggy build: both queries fail with "Optimizer rule 'optimize_projections' failed ... Schema contains duplicate unqualified field name mark", because the mark joins' right children are pruned to zero columns and the marks lose their qualifier.
