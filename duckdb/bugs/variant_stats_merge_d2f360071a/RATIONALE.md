# variant_stats_merge_d2f360071a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d2f360071aa8a49c3240826a4b591f856f13313b ("Fix variant stats merge"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/types/variant/variant_stats_case_sensitive_merge.test
