repro.sql runs `SELECT * FROM unnest_table u, unnest(u.column1)` (and its EXPLAIN) on a small table.
Clean: UNNEST is planned as an implicit LATERAL, so the outer reference resolves and the query fails
later with "Physical plan does not support logical expression OuterReferenceColumn(...)".
Buggy: UNNEST is not lateral, so planning fails with "Schema error: No field named u.column1."
