# keep_constant_compression_uniform_signed_8ee730e384

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 8ee730e384fa2f545f1547c770342ab2a4b61884 ("Keep constant compression for uniform signed zeros in FLOAT/DOUBLE"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/compression/constant/constant_negative_zero.test
