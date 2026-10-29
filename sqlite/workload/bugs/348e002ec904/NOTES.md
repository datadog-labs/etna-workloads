repro.sql: LEFT JOIN whose ON clause is `c IS NULL`, where c comes from a subquery with a constant non-NULL value (`SELECT 3 AS c`).
Clean shell returns `3|` (the left row, padded with NULL). The buggy shell treats the ON-clause `IS NULL` as constant false and drops the row, returning nothing.
