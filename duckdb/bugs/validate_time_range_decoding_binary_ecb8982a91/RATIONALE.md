# validate_time_range_decoding_binary_ecb8982a91

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ecb8982a91e41b43f53057b3d36b09001c05028e ("Validate TIME range when decoding binary Variant values and harden FormatTwoDigits"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/parquet/variant/variant_malicious.test
