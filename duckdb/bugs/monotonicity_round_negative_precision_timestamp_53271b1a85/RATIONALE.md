# monotonicity_round_negative_precision_timestamp_53271b1a85

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 53271b1a85c3ed1e18eb8ba5e016561e0c9c330b ("Fix monotonicity of round with a negative precision, timestamp interval arithmetic and date_trunc across the BC/AD boundary"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/statistics/monotonicity_annotations.test
