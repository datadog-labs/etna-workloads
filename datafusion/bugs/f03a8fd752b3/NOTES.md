Reproducer: two parquet files in `pt/`, table `t` created while `pushdown_filters=false`, then the session sets `datafusion.execution.parquet.pushdown_filters = true` and runs `SELECT a FROM t WHERE b > 2 ORDER BY a`.

Clean: the scan applies the session setting, so the filter is pushed into the reader and the result has 5 rows (baz, foo, 3x NULL).
Buggy: the scan's `pushdown_filters` is not updated from the session config. The parent FilterExec is dropped on the assumption that the scan filters exactly, but the reader doesn't filter. The result has 7 rows, with the extra rows `bar` and a second `foo`, which fail `b > 2`.
