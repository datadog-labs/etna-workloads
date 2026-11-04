Sets `datafusion.optimizer.expand_views_at_output = true` and selects a varchar column from a table.
The output-schema cast to LargeUtf8 loses its alias in the buggy build, so the column header is
`t.b` instead of `b` (in query results and in the EXPLAIN plan). The clean build keeps `b`.
