repro.sql: self-join of an aggregate GROUP BY view with a WHERE on one side (`one.mx=1`).
The WHERE is pushed down into the HAVING of only one copy, so isSelfJoinView must compare HAVING too.
Clean shell returns 3 rows (1|1|1|1, 1|1|2|2, 1|1|3|3); buggy shell treats both as the same subquery and returns wrong rows.
