Reproducer for the DISTINCT-removal bug (ReplaceDistinctWithAggregate).
`users_with_pk` has a primary key; LEFT JOINing it to `user_orders` (id 1 matches twice) downgrades the key to a Multi dependency.
`SELECT DISTINCT u.id ... LEFT JOIN ...` then differs between the builds:
- clean: returns 1, 2 (the DISTINCT is planned as an Aggregate).
- buggy: returns 1, 1, 2 (the DISTINCT is dropped, so duplicates remain; the plan has no AggregateExec).
