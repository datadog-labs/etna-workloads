# add_type_conversion_f127341288

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f127341288110cac2f3553cd47cfa206fee2e3f9 ("add type conversion"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/parquet/timens_parquet.test
- test/sql/types/time/test_time_ns.test
