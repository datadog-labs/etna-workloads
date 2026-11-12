# variant_field_extraction_index_fetch_65c62d1e78

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 65c62d1e787897b7df35eb7f46b755bac5763d5c ("Fix VARIANT field extraction in index fetch"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/types/variant/index_fetch.test
