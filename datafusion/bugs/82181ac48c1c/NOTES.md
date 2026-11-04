repro.sql prepares `SELECT a, b FROM (VALUES ($1, $2)) AS t(a, b)` without declared parameter types, then executes it with (1, 2).
Clean build returns the row `1 | 2`. Buggy build fails with an Arrow error ("column types must match schema types, expected Null but found Int64"), because the VALUES schema is not recomputed after placeholder substitution.
