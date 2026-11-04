`repro.sql` runs the `EXPLAIN ANALYZE` from the upstream fix's joins.slt test: a LEFT ANTI JOIN whose build side is empty after a filter. It sets `analyze_categories = 'rows'` so no timings appear in the output.

Clean build: the HashJoinExec reports `output_rows=2, output_batches=1`.
Buggy build: it reports `output_rows=0, output_batches=0`. The empty-build-side fast path returns the batch directly instead of pushing it to `output_buffer`, so the metrics miss it. Query results are the same on both builds.
