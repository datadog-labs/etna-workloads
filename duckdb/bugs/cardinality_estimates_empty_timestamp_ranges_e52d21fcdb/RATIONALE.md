# cardinality_estimates_empty_timestamp_ranges_e52d21fcdb

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e52d21fcdb32ed29fe3957a4b08207a4da0993ea ("Fix cardinality estimates of empty timestamp ranges and of products of very large inputs"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/table_function/range_cardinality_extremes.test
