# column_drop_c443ee7c62

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c443ee7c622bf0dd7109680fc5769e9dc9927ed0 ("Fix column drop"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/alter/drop_col/test_drop_col_dotted_name.test
