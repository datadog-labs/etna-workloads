# value_decimal_switch_width_instead_fdcccc485c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit fdcccc485c7efbc317e3749687cf68d9a2f4f0f9 ("Fix #6044: in Value::DECIMAL, switch on the width instead of assuming the width is correctly set with the corresponding integer type"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/parquet/parquet_6044.test
