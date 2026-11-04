# Rationale

Changed: `datafusion/datasource-parquet/src/metadata.rs`, `summarize_column_statistics`.

Fix hunk reversed: in `summarize_min_max_null_counts`, the fix replaced
`Precision::Exact(sum or num_rows)` with `Exact(sum)` / `Exact(0)` / `Absent`.
In 55.2.0 that logic lives in `summarize_null_counts`, which still returns `Absent`
when `sum()` is None. The old code reported `Exact(num_rows)` in that case. I
restored that at the call site (`Absent` -> `Exact(num_rows)`), using the `num_rows`
argument that `summarize_column_statistics` still receives. `summarize_null_counts`
keeps its signature, so its unit tests still compile.

Oracle: `parquet.slt` fails.
- The mixed_stats case: column `b` is written with statistics disabled, so null counts are
  unknown. It now claims Exact(num_rows) nulls, i.e. all values null. `WHERE b = 2` then fails with
  "Column 'b' is declared as non-nullable but contains null values".
- The `list_columns` query also fails: its columns return all NULLs, from the same wrong null count.
