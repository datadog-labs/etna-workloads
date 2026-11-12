# case_insensitive_field_match_findshreddedcolumninternal_b35a986b58

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b35a986b581ba30877745af1bfcb24f23da3fb33 ("Fix case-insensitive field match in FindShreddedColumnInternal"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/types/variant/variant_case_sensitive_fields_shredded.test
