# reset_empty_range_timestamp_range_f341cb650e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f341cb650e7b8e5821b905502968312d3bdb43d8 ("Fix: reset empty_range in the TIMESTAMP range() table function"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/table_function/range_timestamp_lateral_empty.test
