# agg_compress_now_that_we_850c5c233c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 850c5c233c4b386b235af471bc791b41e933d32b ("fix agg compress now that we have compare variant function"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/compressed_materialization_variant.test
