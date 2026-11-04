repro.sql writes a parquet file with a struct column and queries it with a user-provided alias `__datafusion_extracted_2`, plus a COALESCE filter on get_field calls.

Clean build: the alias generator skips past the existing `_2`, so the query plans and returns 1.
Buggy build: the generator emits `__datafusion_extracted_2` again, so the rule `push_down_leaf_projections` fails with "Schema contains duplicate unqualified field name __datafusion_extracted_2". The EXPLAIN and the SELECT both error.
