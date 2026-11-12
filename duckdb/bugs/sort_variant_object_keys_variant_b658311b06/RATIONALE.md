# sort_variant_object_keys_variant_b658311b06

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b658311b06bdbdb4e510fef8c3ed998a2832bab8 ("Sort VARIANT object keys in variant_extract_string"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/variant/variant_extract_string.test
- test/sql/function/variant/variant_extract_string_shredded.test
