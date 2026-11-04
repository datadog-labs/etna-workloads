repro.sql creates a 1-row table and runs UNION and UNION ALL between a 1-column and a 2-column SELECT.
Clean build: "Error during planning: UNION queries have different number of columns ..." (raised in the logical plan builder).
Buggy build: the early check is missing, so the error comes later from type coercion ("Union schemas have different number of fields ..."), with a different message.
