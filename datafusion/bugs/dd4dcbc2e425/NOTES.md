repro.sql writes two small parquet files, then queries them with `input_file_name()` in a WHERE clause and `parquet.pushdown_filters = true`.

- df-clean keeps the `input_file_name()` filter out of the parquet row filter. Both queries return the rows from first.parquet, or the rows with `file_row_index() = 2`.
- df-buggy pushes the `input_file_name()` predicate into the parquet scan. Both queries fail with "Parquet error: ... input_file_name() is source dependent and cannot be evaluated directly".
