Writes a Parquet file with struct `s` whose field `x` is Int32, then reads it through an
external table declaring `s STRUCT<x BIGINT>` with `pushdown_filters = true`, so the scan has
to cast the struct column.

`SELECT id, s['x'] FROM t WHERE s['x'] = 200`: clean returns only row (2, 200). Buggy returns
all three rows, because the cast hides the `get_field(column)` pattern and the scan reports
the predicate as handled without applying it (apache/datafusion#24109).
