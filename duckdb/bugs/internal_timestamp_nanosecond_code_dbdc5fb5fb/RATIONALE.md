# internal_timestamp_nanosecond_code_dbdc5fb5fb

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit dbdc5fb5fbced2827697e982a357b2c0fd15bbd3 ("Internal #8974: Timestamp Nanosecond Code"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/types/variant/test_all_types_single_table.test
