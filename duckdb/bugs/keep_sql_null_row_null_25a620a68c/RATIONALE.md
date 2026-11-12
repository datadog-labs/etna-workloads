# keep_sql_null_row_null_25a620a68c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 25a620a68c932c40a71ad5d061ba07da662c69b9 ("Keep a SQL NULL row NULL when casting VARIANT to JSON"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/variant/variant_to_json_null.test
