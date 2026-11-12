# zero_fill_timestamp_ns_f72d15d546

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f72d15d546bd7561152575502bd7e5ac02ceffe5 ("Issue #18035: Zero Fill TIMESTAMP_NS"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/timestamp/test_timestamp_types.test
