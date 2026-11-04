`repro.sql` runs `EXPLAIN ANALYZE` (bytes category only, so output is deterministic) on a sort-merge join whose inputs are in-memory tables.

The injected bug removes `observe_output` in the multi-level merge, so the final output of `SortExec` isn't counted in its metrics.
- df-clean: `SortExec ... output_bytes=60.0 B` and `output_bytes=40.0 B`.
- df-buggy: both `SortExec` nodes report `output_bytes=0.0 B`.

Both exit with status 0.
