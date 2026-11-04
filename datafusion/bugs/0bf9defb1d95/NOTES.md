Reproducer for the decorrelation bugs (copied from the fix's subquery.slt additions).

- Correlated `IN` subquery with an extra `>` correlated filter: the buggy build treats the
  `=` IN-predicate and the `>` filter as duplicates (operator-precedence bug) and drops the
  filter, so it returns rows 1,2,3 instead of the correct empty result.
- Scalar subquery `count(*) AS id` compared with outer `id`: the buggy build rewrites the
  outer `id` column too, so `WHERE id > (...)` returns no rows instead of 2,3.
