repro.sql runs recursive CTEs whose anchor term is non-null (`SELECT 1 AS a`) but whose recursive term produces NULLs (`CAST(NULL AS INT)`), taken from the new cte.slt tests.

The buggy build takes the RecursiveQuery schema from the static term only, so the column is wrongly non-nullable. The differences are:
- `WHERE a IS NULL` returns no rows instead of NULL.
- A two-column query fails with "Column 'a' is declared as non-nullable but contains null values".
- DESCRIBE reports is_nullable NO instead of YES.
