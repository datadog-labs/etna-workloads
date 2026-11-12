# correctly_expand_type_count_csv_e4a7ecdff5

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e4a7ecdff506e95a276ef6feaf97b28435aec776 ("Fix #21248: correctly expand type count in CSV header detection"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/21248.test
