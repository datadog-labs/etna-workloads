# require_column_set_drop_not_c5f9a375f8

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c5f9a375f829c0153da45eb6d9d320551bc01d0a ("Require a column for SET / DROP NOT NULL in ALTER TABLE"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/alter/alter_table_nullability_requires_column.test
