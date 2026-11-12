# 64_byte_variant_strings_written_104fc7326d

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 104fc7326d1710cb292d97e1d667d7fe31912727 ("Fix 64-byte VARIANT strings written as empty short strings to Parquet"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/parquet/variant/variant_short_string_boundary.test
