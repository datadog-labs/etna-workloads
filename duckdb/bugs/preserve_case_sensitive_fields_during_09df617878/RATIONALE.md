# preserve_case_sensitive_fields_during_09df617878

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 09df6178785208006bffd1373e7dff368b9386f9 ("Preserve case-sensitive fields during variant shredding"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/parquet/variant/pushdown/variant_case_sensitivity.test
- test/sql/storage/types/variant/variant_case_sensitive_fields_shredded.test
