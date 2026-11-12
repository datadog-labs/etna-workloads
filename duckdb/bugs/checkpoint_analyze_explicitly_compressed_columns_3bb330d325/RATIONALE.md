# checkpoint_analyze_explicitly_compressed_columns_3bb330d325

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 3bb330d32532c606359af46339560784944db185 ("Fix checkpoint Analyze for explicitly compressed columns"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/compression/skip_explicit_compression_analyze.test
